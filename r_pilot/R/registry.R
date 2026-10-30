# Variable registry (variables.csv): one row per variable the pipeline
# computes. Everything that used to be listed by hand (raw columns to read,
# computation order, output columns and order, parity tolerances, docs
# snippets) is derived from it.
#
# Columns:
#   variable   output column name
#   family     grouping for docs and porting order
#   stage      "basic" (every basic row) or "wages" (the wage adjustments, run on
#                the whole Basic and ORG tables after every basic variable)
#   kind       "column": fn's arguments are column names (or context objects) and it
#                returns the new column
#              "table": fn takes the stage table first and returns it with the new
#                column added; `depends` lists the columns it reads
#   depends    table kind only: semicolon-separated columns read (any source)
#   export     TRUE = written to the extracts and parity-checked; FALSE = intermediate
#   samples    samples the exported column appears in ("basic;org" or "org")
#   tolerance  parity tolerance: 0 = exact, 0.01 for Stata float columns (weights, dollars)
#   stata_type "integer" if the Stata script creates it as byte/int/long (so
#                Stata promotes it to long, never float, when values grow);
#                blank = Stata's default float
#   label      variable label (Stata/haven); value labels live in value_labels.csv
#   snippet    functions shown on the docs site ("fn1;fn2" or "file:<R file>"); blank = none
#
# Recode functions live in variable_functions.csv, one row per variable and
# data source (variable, source, fn). A source is a kind of input file:
#   census_basic  Census Basic monthly files, 1994+
#   unicon_basic  Unicon Basic monthly files, 1976-1993 (R/unicon.R)
#   unicon_may    Unicon May supplement files, 1973-1981 (R/may.R)
#   unicon_march  Unicon March (ASEC) files, 1962-1997 (R/march.R)
#   census_march  Census March (ASEC) files from 1998, as Stata output (R/march.R)
# Each table comes wholly from one source and runs that source's functions;
# the same function under two sources means one rule for both. Every
# variable needs a function for every source (unicon_missing when there is
# no data).

# objects recode functions can take besides columns
context_names <- c("reweight_years", "state_geocodes", "wage_bounds", "mocc10_crosswalk", "telework_files")

# first year of the Census era; earlier years are Unicon
census_first_year <- 1994

#' Data source of a Basic/ORG table from its years: "unicon_basic" (all before
#' 1994) or "census_basic" (all 1994+). An empty table counts as Census.
data_source <- function(year) {
  if (length(year) == 0 || all(year >= census_first_year)) return("census_basic")
  if (all(year < census_first_year)) return("unicon_basic")
  stop("a table mixes Unicon-era and Census-era years: ", paste(range(year), collapse = "-"))
}

#' Each variable's recode function for one source, in registry order.
source_fns <- function(registry, source) registry[[paste0("fn_", source)]]

#' The data sources the registry has functions for.
registry_sources <- function(registry) sub("^fn_", "", grep("^fn_", names(registry), value = TRUE))

#' Read variables.csv and attach each source's functions from
#' variable_functions.csv (as fn_<source> columns). Stops if a variable lacks
#' a function for some source, or a function row names an unknown variable.
#' Samples whose published column order differs from the registry's (March)
#' have their order in sample_columns.csv (kept as an attribute).
read_registry <- function(registry_file, functions_file = file.path(dirname(registry_file), "variable_functions.csv"),
                          columns_file = file.path(dirname(registry_file), "sample_columns.csv")) {
  # labels can end in a space (offpovcut), so nothing is trimmed
  registry <- readr::read_csv(registry_file, col_types = readr::cols(.default = "c"), na = "", trim_ws = FALSE) |>
    dplyr::mutate(
      export = export == "TRUE",
      tolerance = as.numeric(tolerance),
      dplyr::across(c(depends, label, snippet, stata_type), ~ dplyr::coalesce(.x, ""))
    )
  functions <- readr::read_csv(functions_file, col_types = "ccc")
  unknown <- setdiff(functions$variable, registry$variable)
  if (length(unknown) > 0) stop("variable_functions.csv names unknown variables: ", paste(unknown, collapse = ", "))
  # one fn_<source> column per source
  for (src in unique(functions$source)) {
    rows <- functions[functions$source == src, ]
    registry[[paste0("fn_", src)]] <- rows$fn[match(registry$variable, rows$variable)]
  }
  incomplete <- registry$variable[!stats::complete.cases(registry[, grep("^fn_", names(registry))])]
  if (length(incomplete) > 0) stop("variables without a function for every source: ", paste(incomplete, collapse = ", "))
  if (file.exists(columns_file)) attr(registry, "sample_columns") <- readr::read_csv(columns_file, col_types = "cc")
  registry
}

#' The recode functions the registry names, as a named list. Target commands
#' take this list (not function names), so targets re-runs a step when any
#' recode function it uses changes.
registry_functions <- function(registry) {
  fns <- unique(unlist(registry[, paste0("fn_", registry_sources(registry))], use.names = FALSE))
  missing <- fns[!vapply(fns, exists, logical(1), mode = "function")]
  if (length(missing) > 0) stop("registry names undefined functions: ", paste(missing, collapse = ", "))
  purrr::set_names(purrr::map(fns, ~ get(.x, mode = "function")), fns)
}

#' Columns each variable reads: its function's arguments (column kind) or its
#' declared depends (table kind). For one source, or (source = NULL) every
#' source, which is what the computation order needs.
registry_inputs <- function(registry, recode_functions, source = NULL) {
  sources <- if (is.null(source)) registry_sources(registry) else source
  purrr::map(seq_len(nrow(registry)), function(i) {
    if (registry$kind[i] == "table") return(strsplit(registry$depends[i], ";")[[1]])
    sources |>
      purrr::map(~ names(formals(recode_functions[[source_fns(registry, .x)[i]]]))) |>
      unlist() |>
      unique()
  }) |>
    purrr::set_names(registry$variable)
}

#' Raw columns to read for one source: inputs that no registry variable produces
#' (a variable reading a raw column of its own name, like hrhhid, counts as raw).
registry_raw_columns <- function(registry, recode_functions, source = "census_basic") {
  inputs <- registry_inputs(registry, recode_functions, source)
  purrr::imap(inputs, ~ .x[.x == .y | !.x %in% registry$variable]) |>
    unlist(use.names = FALSE) |>
    setdiff(c(context_names, file_columns)) |>
    unique()
}

#' Variables of one stage computed for the given samples: those exported in
#' any of them, every intermediate (export FALSE), and whatever these read
#' (indcode is exported only in March but feeds Basic's ind70, ind90, ...).
#' NULL = all. Keeps e.g. Basic years from carrying March-only columns.
stage_variables <- function(registry, stage, samples = NULL, recode_functions = registry_functions(registry)) {
  in_stage <- registry$stage == stage
  if (is.null(samples)) return(registry$variable[in_stage])
  in_samples <- purrr::map_lgl(strsplit(dplyr::coalesce(registry$samples, ""), ";"), ~ any(samples %in% .x))
  keep <- registry$variable[in_samples | !registry$export]
  # add the registry variables these read, until nothing new appears
  inputs <- registry_inputs(registry, recode_functions)
  repeat {
    needed <- intersect(unique(unlist(inputs[keep])), registry$variable)
    if (all(needed %in% keep)) break
    keep <- union(keep, needed)
  }
  registry$variable[in_stage & registry$variable %in% keep]
}

#' Computation order for one stage: dependencies first (Kahn's algorithm).
#' Variables from earlier stages count as already available.
stage_order <- function(registry, recode_functions, stage, samples = NULL) {
  inputs <- registry_inputs(registry, recode_functions)
  todo <- stage_variables(registry, stage, samples, recode_functions)
  done <- character(0)
  while (length(todo) > 0) {
    # a variable is ready once every registry variable it reads (in this stage) is done
    ready <- todo[purrr::map_lgl(todo, ~ all(setdiff(intersect(inputs[[.x]], todo), .x) %in% done))]
    if (length(ready) == 0) stop("dependency cycle among: ", paste(todo, collapse = ", "))
    done <- c(done, ready)
    todo <- setdiff(todo, ready)
  }
  done
}

#' Compute every variable of one stage, in dependency order, with the
#' functions of the table's source: given, or for Basic/ORG worked out from
#' the years. `samples` limits it to the variables those samples use (see
#' stage_variables()). An empty table (e.g. ORG before 1979) just gets the columns.
run_stage <- function(data, registry, recode_functions, stage, context, source = NULL, samples = NULL) {
  if (nrow(data) == 0) {
    for (v in stage_variables(registry, stage, samples, recode_functions)) data[[v]] <- numeric(0)
    return(data)
  }
  # the basic stage starts before year exists: use the file's year
  if (is.null(source)) source <- data_source(if ("year" %in% names(data)) data$year else data$file_year)
  fn_column <- source_fns(registry, source)
  for (v in stage_order(registry, recode_functions, stage, samples)) {
    entry <- registry[registry$variable == v, ]
    fn_name <- fn_column[registry$variable == v]
    fn <- recode_functions[[fn_name]]
    args <- names(formals(fn))
    if (entry$kind == "column") {
      # each argument is a column of the table, or else a context object
      values <- purrr::map(args, ~ if (.x %in% names(data)) data[[.x]] else context[[.x]])
      # stored as Stata stores it: beyond float range is missing
      data[[v]] <- stata_store(do.call(fn, values))
    } else {
      data <- do.call(fn, c(list(data), context[intersect(args[-1], names(context))]))
      if (!v %in% names(data)) stop(fn_name, " did not create ", v)
      data[[v]] <- stata_store(data[[v]])
    }
  }
  data
}

# Variable labels Stata leaves unset for a sample: generate_cmpwgt.do labels
# cmpwgt inside its Basic-only ($monthlycps) branch, so May files leave it
# unlabelled.
sample_label_overrides <- tibble::tribble(
  ~sample, ~variable, ~label,
  "may",   "cmpwgt",  ""
)

#' Variable labels for one sample, named by variable: the registry's, with
#' sample_label_overrides applied.
sample_labels <- function(registry, sample) {
  labels <- stats::setNames(registry$label, registry$variable)
  overrides <- sample_label_overrides[sample_label_overrides$sample == sample, ]
  labels[overrides$variable] <- overrides$label
  labels
}

# years whose published files have statefips before division and region and
# statecensus after them (generate_statefips.do merges the geocodes that way)
state_swap_years <- list(basic = 1978:1993, org = 1978:1993, may = 1978:1993, march = 1977:2000)

#' Exported columns for one sample, in published order: the registry order,
#' or the sample's own order from sample_columns.csv (March). In
#' state_swap_years, statefips and statecensus swap places.
export_columns <- function(registry, sample, year = NULL) {
  columns <- registry$variable[registry$export & purrr::map_lgl(strsplit(registry$samples, ";"), ~ sample %in% .x)]
  own_order <- attr(registry, "sample_columns")
  if (!is.null(own_order) && sample %in% own_order$sample) {
    order <- own_order$variable[own_order$sample == sample]
    columns <- order[order %in% columns]
  }
  if (length(year) == 1 && year %in% state_swap_years[[sample]]) {
    swap <- match(c("statecensus", "statefips"), columns)
    columns[swap] <- c("statefips", "statecensus")
  }
  columns
}
