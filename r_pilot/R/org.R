# Stage runners: raw year -> basic table -> Basic and ORG extracts.

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
  read_raw_year(raw_files, registry_raw_columns(registry, recode_functions), context$telework_files) |>
    filter_basic_universe() |>
    run_stage(registry, recode_functions, "basic", context) |>
    dplyr::select(dplyr::all_of(registry$variable[registry$stage == "basic"]))
}

#' The previous year's months in a partial year's trailing window, recoded
#' from the raw cache like any basic table (spec: see build_year_spec()).
#'
#' For a partial year, Stata (create_extracts.ado) runs the wage adjustments
#' on a trailing window: the previous year's months after the current year's
#' month count (e.g. 2025m10-m12 for 2026m1-m9). Full years have no window
#' and get an empty table, so their extracts don't depend on other years'
#' raw files.
recode_trailing_window <- function(spec, raw_files, registry, recode_functions, context) {
  if (!spec$partial) return(tibble::tibble(year = numeric(0)))
  window_files <- raw_files[basename(raw_files) %in% sprintf("%d_%02d.parquet", spec$year - 1, spec$window_months)]
  recode_basic_year(window_files, registry, recode_functions, context)
}

#' One year's extract for a sample: the basic table (ORG: after the ORG
#' universe filter), then the wage-adjustment stage (hoursu1i imputation ->
#' weekpay top-coding -> wage -> wageotc), which adjust_wages.do runs on the
#' Basic and on the ORG file separately. A partial year's adjustments run
#' over its trailing window (recode_trailing_window()), then only the
#' current year is kept.
build_extract_year <- function(basic_year, trailing_window, registry, recode_functions, context, sample) {
  yr <- unique(basic_year$year)
  window <- dplyr::bind_rows(trailing_window, basic_year)
  if (sample == "org") window <- filter_org_universe(window)
  window |>
    run_stage(registry, recode_functions, "wages", context) |>
    dplyr::filter(year == yr) |>
    dplyr::select(dplyr::all_of(export_columns(registry, sample)))
}
