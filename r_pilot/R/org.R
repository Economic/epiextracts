# Stage runners: raw year -> basic table -> Basic and ORG extracts.

#' Basic universe filter (sample_cpsbasic.do): drop rows with negative raw
#' age (Unicon years: missing age) entirely, before any variable is computed
#' (as in Stata, so e.g. the hhid numbering only counts the households that
#' remain). Distinct from recode_age(), which sets age to missing.
filter_basic_universe <- function(raw) {
  if (data_era(raw$file_year) == "unicon") return(dplyr::filter(raw, !is.na(u_age)))
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
#' needs for the files' era, apply the basic universe, compute every
#' basic-stage variable, keep registry columns. `source` picks the basic
#' monthly files or the separate ORG files (1979-1983).
recode_basic_year <- function(raw_files, registry, recode_functions, context, source = c("basic", "org")) {
  source <- match.arg(source)
  raw_files <- raw_files[is_org_file(raw_files) == (source == "org")]
  years <- as.integer(sub("^(org_)?([0-9]{4})_.*$", "\\2", basename(raw_files)))
  columns <- registry_raw_columns(registry, recode_functions, data_era(years))
  read_raw_year(raw_files, columns, context$telework_files) |>
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
#'
#' ORG for 1979-1983 comes from separate Unicon ORG files (raw_files has
#' them as org_YYYY_MM.parquet), recoded like a basic table; before 1979
#' there is no ORG, and the universe filter leaves an empty table.
build_extract_year <- function(basic_year, trailing_window, raw_files, registry, recode_functions, context, sample) {
  yr <- unique(basic_year$year)
  window <- dplyr::bind_rows(trailing_window, basic_year)
  if (sample == "org" && any(is_org_file(raw_files))) {
    window <- recode_basic_year(raw_files, registry, recode_functions, context, source = "org")
  }
  if (sample == "org") window <- filter_org_universe(window)
  window |>
    run_stage(registry, recode_functions, "wages", context) |>
    dplyr::filter(year == yr) |>
    dplyr::select(dplyr::all_of(export_columns(registry, sample, yr)))
}
