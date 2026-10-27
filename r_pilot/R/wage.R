# wage (generate_wage.do): assembled from wage_noadj/weekpay/hoursu1(i) and
# trimmed by the CPI-based limits from build_wage_bounds() (R/cpi.R).

#' Assemble wage from wage_noadj/weekpay/hoursu1(i), trimmed by CPI bounds.
#' (generate_wage.do, Census era Basic/ORG 1994+)
add_wage <- function(org_year, wage_bounds) {
  # each row is trimmed with its own year's limits (a partial year's window spans two years)
  org_year |>
    dplyr::left_join(wage_bounds, by = "year") |>
    dplyr::mutate(
      # nonhourly workers: weekpay/hoursu1, using the imputed hoursu1i instead
      # when hours vary -- overwrites, doesn't branch, matching generate_wage.do
      wage2_adjusted = dplyr::case_when(
        paidhre == 0 & hoursvary1 == 1 & !is.na(hoursu1i) & hoursu1i > 0 ~ weekpay / hoursu1i,
        paidhre == 0 & (!is.na(hoursu1) & hoursu1 > 0) ~ weekpay / hoursu1,
        TRUE ~ NA_real_
      ),
      wage2_adjusted = dplyr::if_else(wage2_adjusted < 0, NA_real_, wage2_adjusted, missing = wage2_adjusted),
      wage = dplyr::if_else(paidhre == 1, wage_noadj, wage2_adjusted, missing = wage2_adjusted),
      wage = dplyr::if_else(wage < wage_lower | wage > wage_upper, NA_real_, wage, missing = wage)
    ) |>
    dplyr::select(-wage2_adjusted, -wage_lower, -wage_upper)
}
