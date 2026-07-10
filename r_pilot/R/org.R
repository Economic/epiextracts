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
#' imputation -> weekpay (Pareto top-code) -> wage (assemble + CPI trim) ->
#' tc_fix retroactive correction (no-op outside 2023/2024).
recode_org_year <- function(recoded_year, raw_year, wage_bounds, tc_constants) {
  filter_org_universe(recoded_year) |>
    compute_hoursu1i(raw_year) |>
    add_weekpay() |>
    add_wage(wage_bounds) |>
    apply_tc_fix(tc_constants, wage_bounds)
}
