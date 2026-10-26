# Stage runners: raw year -> basic table -> ORG table.

#' Basic universe filter (sample_cpsbasic.do): drop rows with negative raw
#' age entirely. Distinct from recode_age(), which sets age to missing; this
#' is what makes row counts match the published extracts.
filter_basic_universe <- function(data) {
  dplyr::filter(data, raw_age >= 0)
}

#' ORG universe filter (sample_cpsorg.do): outgoing rotation groups, positive
#' orgwgt, age >= 16. Uses the recoded (top-coded) age, not raw age.
filter_org_universe <- function(data) {
  dplyr::filter(
    data,
    minsamp %in% c(4, 8),
    !is.na(orgwgt), orgwgt > 0,
    !is.na(age), age >= 16
  )
}

#' One year's basic table: read the raw columns the registry needs, compute
#' every basic-stage variable, apply the basic universe, keep registry columns.
recode_basic_year <- function(raw_files, registry, recode_functions, context) {
  read_raw_year(raw_files, registry_raw_columns(registry, recode_functions)) |>
    run_stage(registry, recode_functions, "basic", context) |>
    filter_basic_universe() |>
    dplyr::select(dplyr::all_of(registry$variable[registry$stage == "basic"]))
}

#' One year's ORG table: ORG universe, then the ORG-stage variables
#' (hoursu1i imputation -> weekpay top-coding -> wage).
recode_org_year <- function(basic_year, registry, recode_functions, context) {
  filter_org_universe(basic_year) |>
    run_stage(registry, recode_functions, "org", context) |>
    dplyr::select(dplyr::all_of(registry$variable))
}
