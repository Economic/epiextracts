year_to_reference_path <- function(year, reference_dir) {
  file.path(reference_dir, sprintf("epi_cpsbasic_%d.dta", year))
}

read_reference_year <- function(reference_path) {
  haven::read_dta(
    reference_path,
    col_select = c(hrhhid, hhid, personid, year, month, age, female, emp, basicwgt)
  ) |>
    dplyr::mutate(dplyr::across(c(age, female, emp, basicwgt), as.numeric))
}

#' Compare one year's R-recoded output against the published Stata extract.
#'
#' Joins on (hrhhid, hhid, personid, year, month) -- verified unique in the
#' reference extracts and sufficient for 100% row recovery. tol is an
#' absolute tolerance: basicwgt/cmpwgt carry Stata `float` rounding noise
#' (up to ~5e-4 on values in the thousands) against R's `double`, while
#' age/female/emp are integer-valued and compare exactly regardless.
compare_year <- function(recoded_year, reference_path, tol = 0.01) {
  year <- unique(recoded_year$year)
  reference_year <- read_reference_year(reference_path)

  join_keys <- c("hrhhid", "hhid", "personid", "year", "month")

  matched <- dplyr::inner_join(
    recoded_year, reference_year,
    by = join_keys, suffix = c("_r", "_stata")
  )
  only_r <- dplyr::anti_join(recoded_year, reference_year, by = join_keys)
  only_stata <- dplyr::anti_join(reference_year, recoded_year, by = join_keys)

  var_summary <- purrr::map_dfr(c("age", "female", "emp", "basicwgt"), function(v) {
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
      year = year,
      n_r_rows = nrow(recoded_year),
      n_stata_rows = nrow(reference_year),
      n_only_r = nrow(only_r),
      n_only_stata = nrow(only_stata),
      .before = 1
    )
}
