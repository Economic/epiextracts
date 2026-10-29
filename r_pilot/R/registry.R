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
#   fn         recode function name (Census era, 1994+)
#   fn_unicon  recode function for Unicon-era years (1976-1993; R/unicon.R).
#                Every year is wholly one era, so each year runs one era's
#                functions; the same name in both columns means one rule for both
#   depends    table kind only: semicolon-separated columns read (either era)
#   export     TRUE = written to the extracts and parity-checked; FALSE = intermediate
#   samples    samples the exported column appears in ("basic;org" or "org")
#   tolerance  parity tolerance: 0 = exact, 0.01 for Stata float columns (weights, dollars)
#   label      variable label (Stata/haven); value labels live in value_labels.csv
#   snippet    functions shown on the docs site ("fn1;fn2" or "file:<R file>"); blank = none

# objects recode functions can take besides columns
context_names <- c("reweight_years", "state_geocodes", "wage_bounds", "mocc10_crosswalk", "telework_files")

# first year of the Census era; earlier years are Unicon
census_first_year <- 1994

#' Era of a table of years: "unicon" (all before 1994) or "census" (all 1994+).
#' An empty table counts as Census era.
data_era <- function(year) {
  if (length(year) == 0 || all(year >= census_first_year)) return("census")
  if (all(year < census_first_year)) return("unicon")
  stop("a table mixes Unicon-era and Census-era years: ", paste(range(year), collapse = "-"))
}

#' The recode function column for an era.
era_fns <- function(registry, era) if (era == "unicon") registry$fn_unicon else registry$fn

read_registry <- function(registry_file) {
  readr::read_csv(registry_file, col_types = readr::cols(.default = "c"), na = "") |>
    dplyr::mutate(
      export = export == "TRUE",
      tolerance = as.numeric(tolerance),
      dplyr::across(c(depends, label, snippet), ~ dplyr::coalesce(.x, ""))
    )
}

#' The recode functions the registry names, as a named list. Target commands
#' take this list (not function names), so targets re-runs a step when any
#' recode function it uses changes.
registry_functions <- function(registry) {
  fns <- unique(c(registry$fn, registry$fn_unicon))
  missing <- fns[!vapply(fns, exists, logical(1), mode = "function")]
  if (length(missing) > 0) stop("registry names undefined functions: ", paste(missing, collapse = ", "))
  purrr::set_names(purrr::map(fns, ~ get(.x, mode = "function")), fns)
}

#' Columns each variable reads: its function's arguments (column kind) or its
#' declared depends (table kind). For one era, or (era = NULL) both eras,
#' which is what the computation order needs.
registry_inputs <- function(registry, recode_functions, era = NULL) {
  eras <- if (is.null(era)) c("census", "unicon") else era
  purrr::map(seq_len(nrow(registry)), function(i) {
    if (registry$kind[i] == "table") return(strsplit(registry$depends[i], ";")[[1]])
    eras |>
      purrr::map(~ names(formals(recode_functions[[era_fns(registry, .x)[i]]]))) |>
      unlist() |>
      unique()
  }) |>
    purrr::set_names(registry$variable)
}

#' Raw columns to read for one era: inputs that no registry variable produces
#' (a variable reading a raw column of its own name, like hrhhid, counts as raw).
registry_raw_columns <- function(registry, recode_functions, era = "census") {
  inputs <- registry_inputs(registry, recode_functions, era)
  purrr::imap(inputs, ~ .x[.x == .y | !.x %in% registry$variable]) |>
    unlist(use.names = FALSE) |>
    setdiff(c(context_names, file_columns)) |>
    unique()
}

#' Computation order for one stage: dependencies first (Kahn's algorithm).
#' Variables from earlier stages count as already available.
stage_order <- function(registry, recode_functions, stage) {
  inputs <- registry_inputs(registry, recode_functions)
  todo <- registry$variable[registry$stage == stage]
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
#' functions of the table's era. An empty table (e.g. ORG before 1979) just
#' gets the columns.
run_stage <- function(data, registry, recode_functions, stage, context) {
  if (nrow(data) == 0) {
    for (v in registry$variable[registry$stage == stage]) data[[v]] <- numeric(0)
    return(data)
  }
  # the basic stage starts before year exists: use the file's year
  fn_column <- era_fns(registry, data_era(if ("year" %in% names(data)) data$year else data$file_year))
  for (v in stage_order(registry, recode_functions, stage)) {
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

#' Exported columns for one sample, in registry (= published) order. In
#' 1978-1993 the published files have statefips before division and region
#' and statecensus after them (generate_statefips.do merges the geocodes that
#' way in those years), so the two swap places.
export_columns <- function(registry, sample, year = NULL) {
  columns <- registry$variable[registry$export & purrr::map_lgl(strsplit(registry$samples, ";"), ~ sample %in% .x)]
  if (length(year) == 1 && year >= 1978 && year < census_first_year) {
    swap <- match(c("statecensus", "statefips"), columns)
    columns[swap] <- c("statefips", "statecensus")
  }
  columns
}
