#' Path to the published Stata reference extract for a given year/sample.
#'
#' Points at the deployed copies under reference_dir/<sample>/epi/ (the
#' Makefile's `deploydata` target rsyncs extracts/ there after each release)
#' rather than the project-local extracts/ directory, which isn't guaranteed
#' to be populated on every machine this pipeline runs on.
year_to_reference_path <- function(year, reference_dir, sample = "basic") {
  file.path(reference_dir, sample, "epi", sprintf("epi_cps%s_%d.dta", sample, year))
}

read_reference_year <- function(reference_path, variables) {
  join_keys <- c("hrhhid", "hhid", "personid", "year", "month")
  haven::read_dta(
    reference_path,
    col_select = dplyr::all_of(c(join_keys, variables))
  ) |>
    dplyr::mutate(dplyr::across(dplyr::all_of(variables), as.numeric))
}

#' Compare one year's R-recoded output against the published Stata extract.
#'
#' Joins on (hrhhid, hhid, personid, year, month) -- verified unique in the
#' reference extracts and sufficient for 100% row recovery. tol is an
#' absolute tolerance: weight/dollar/hours variables carry Stata `float`
#' rounding noise (up to ~5e-4 on values in the thousands) against R's
#' `double`, while integer-valued variables (age/female/emp) compare exactly
#' regardless. `sample` ("basic"/"org") is carried through as a report column
#' so one unified report can cover both samples.
compare_year <- function(recoded_year, reference_path, variables, sample = "basic", tol = 0.01) {
  year <- unique(recoded_year$year)
  reference_year <- read_reference_year(reference_path, variables)

  join_keys <- c("hrhhid", "hhid", "personid", "year", "month")

  matched <- dplyr::inner_join(
    recoded_year, reference_year,
    by = join_keys, suffix = c("_r", "_stata")
  )
  only_r <- dplyr::anti_join(recoded_year, reference_year, by = join_keys)
  only_stata <- dplyr::anti_join(reference_year, recoded_year, by = join_keys)

  var_summary <- purrr::map_dfr(variables, function(v) {
    r_col <- matched[[paste0(v, "_r")]]
    s_col <- matched[[paste0(v, "_stata")]]
    missingness_mismatch <- is.na(r_col) != is.na(s_col)
    value_mismatch <- !missingness_mismatch & !is.na(r_col) & abs(r_col - s_col) > tol
    tibble::tibble(
      variable = v,
      n_compared = nrow(matched),
      n_missingness_mismatch = sum(missingness_mismatch),
      n_value_mismatch = sum(value_mismatch),
      pct_mismatch = round(100 * (sum(missingness_mismatch) + sum(value_mismatch)) / nrow(matched), 4)
    )
  })

  var_summary |>
    dplyr::mutate(
      sample = sample,
      year = year,
      n_r_rows = nrow(recoded_year),
      n_stata_rows = nrow(reference_year),
      n_only_r = nrow(only_r),
      n_only_stata = nrow(only_stata),
      .before = 1
    )
}
