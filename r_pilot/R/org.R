#' ORG universe filter (sample_cpsorg.do): outgoing rotation groups, positive
#' orgwgt, age >= 16. Uses the RECODED (top-coded) age, not raw age.
filter_org_universe <- function(recoded_year) {
  recoded_year |>
    dplyr::filter(
      minsamp %in% c(4, 8),
      !is.na(orgwgt), orgwgt > 0,
      !is.na(age), age >= 16
    )
}

#' Full per-year ORG pipeline: universe filter -> hoursu1i regression
#' imputation -> weekpay (era-aware Pareto top-code, including the
#' 2023-2024 dynamic top-code phase-in) -> wage (assemble + CPI trim).
recode_org_year <- function(recoded_year, wage_bounds) {
  filter_org_universe(recoded_year) |>
    compute_hoursu1i() |>
    add_weekpay() |>
    add_wage(wage_bounds)
}
