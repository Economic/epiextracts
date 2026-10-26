# Variable registry (variables.csv): one row per variable the pipeline
# computes. Everything that used to be listed by hand (raw columns to read,
# computation order, output columns and order, parity tolerances, docs
# snippets) is derived from it.
#
# Columns:
#   variable   output column name
#   family     grouping for docs and porting order
#   stage      "basic" (every basic row) or "org" (after the ORG universe filter)
#   kind       "column": fn's arguments are column names (or context objects) and it
#                returns the new column
#              "table": fn takes the stage table first and returns it with the new
#                column added; `depends` lists the columns it reads
#   fn         recode function name
#   depends    table kind only: semicolon-separated columns read
#   export     TRUE = written to the extracts and parity-checked; FALSE = intermediate
#   samples    samples the exported column appears in ("basic;org" or "org")
#   tolerance  parity tolerance: 0 = exact, 0.01 for Stata float columns (weights, dollars)
#   label      variable label (Stata/haven); value labels live in value_labels.csv
#   snippet    functions shown on the docs site ("fn1;fn2" or "file:<R file>"); blank = none

# objects recode functions can take besides columns
context_names <- c("reweight_years", "state_geocodes", "wage_bounds")

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
  fns <- unique(registry$fn)
  missing <- fns[!vapply(fns, exists, logical(1), mode = "function")]
  if (length(missing) > 0) stop("registry names undefined functions: ", paste(missing, collapse = ", "))
  purrr::set_names(purrr::map(fns, ~ get(.x, mode = "function")), fns)
}

#' Columns each variable reads: its function's arguments (column kind) or its
#' declared depends (table kind).
registry_inputs <- function(registry, recode_functions) {
  purrr::pmap(registry, function(kind, fn, depends, ...) {
    if (kind == "table") strsplit(depends, ";")[[1]] else names(formals(recode_functions[[fn]]))
  }) |>
    purrr::set_names(registry$variable)
}

#' Raw columns to read: inputs that no registry variable produces (a variable
#' reading a raw column of its own name, like hrhhid, counts as raw).
registry_raw_columns <- function(registry, recode_functions) {
  inputs <- registry_inputs(registry, recode_functions)
  purrr::imap(inputs, ~ .x[.x == .y | !.x %in% registry$variable]) |>
    unlist(use.names = FALSE) |>
    setdiff(context_names) |>
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

#' Compute every variable of one stage, in dependency order.
run_stage <- function(data, registry, recode_functions, stage, context) {
  for (v in stage_order(registry, recode_functions, stage)) {
    entry <- registry[registry$variable == v, ]
    fn <- recode_functions[[entry$fn]]
    args <- names(formals(fn))
    if (entry$kind == "column") {
      # each argument is a column of the table, or else a context object
      values <- purrr::map(args, ~ if (.x %in% names(data)) data[[.x]] else context[[.x]])
      data[[v]] <- do.call(fn, values)
    } else {
      data <- do.call(fn, c(list(data), context[intersect(args[-1], names(context))]))
      if (!v %in% names(data)) stop(entry$fn, " did not create ", v)
    }
  }
  data
}

#' Exported columns for one sample, in registry (= published) order.
export_columns <- function(registry, sample) {
  registry$variable[registry$export & purrr::map_lgl(strsplit(registry$samples, ";"), ~ sample %in% .x)]
}
