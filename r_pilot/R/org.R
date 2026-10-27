# Stage runners: raw year -> basic table -> ORG table.

#' Basic universe filter (sample_cpsbasic.do): drop rows with negative raw
#' age entirely, before any variable is computed (as in Stata, so e.g. the
#' 1994-1997 hhid numbering only counts the households that remain).
#' Distinct from recode_age(), which sets age to missing.
filter_basic_universe <- function(raw) {
  dplyr::filter(raw, recode_raw_age(peage, prtage) >= 0)
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

#' Basic table for a set of raw months: read the raw columns the registry
#' needs, apply the basic universe, compute every basic-stage variable, keep
#' registry columns.
recode_basic_year <- function(raw_files, registry, recode_functions, context) {
  read_raw_year(raw_files, registry_raw_columns(registry, recode_functions)) |>
    filter_basic_universe() |>
    run_stage(registry, recode_functions, "basic", context) |>
    dplyr::select(dplyr::all_of(registry$variable[registry$stage == "basic"]))
}

#' One year's ORG table: ORG universe, then the ORG-stage variables
#' (hoursu1i imputation -> weekpay top-coding -> wage).
#'
#' For a partial year, Stata (create_extracts.ado) runs these on a trailing
#' window: the previous year's months after the current year's month count
#' (e.g. 2025m10-m12 for 2026m1-m9), then keeps the current year. The
#' previous months are recoded from the raw cache the same way.
recode_org_year <- function(basic_year, raw_files, registry, recode_functions, context, config) {
  yr <- unique(basic_year$year)
  window <- basic_year
  if (is_partial_year(yr, config)) {
    prev_months <- seq(length(year_months(yr, config)) + 1, 12)
    prev_files <- raw_files[basename(raw_files) %in% sprintf("%d_%02d.parquet", yr - 1, prev_months)]
    window <- dplyr::bind_rows(recode_basic_year(prev_files, registry, recode_functions, context), basic_year)
  }
  filter_org_universe(window) |>
    run_stage(registry, recode_functions, "org", context) |>
    dplyr::filter(year == yr) |>
    dplyr::select(dplyr::all_of(registry$variable))
}
