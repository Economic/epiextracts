# CPI-based wage trim bounds. Uses realtalk::cpi_u_rs_annual in place of
# reading suppdata/cpiurs_extended.csv directly -- verified numerically
# identical (zero deviation) to the CSV for every year 1978-2024, which fully
# covers the 1989 base year and this pipeline's 2000-2024 target range.
build_wage_bounds <- function() {
  cpi <- realtalk::cpi_u_rs_annual
  cpibase <- cpi$cpi_u_rs[cpi$year == 1989]
  dplyr::transmute(
    cpi,
    year,
    wage_lower = stata_round(0.50 * cpi_u_rs / cpibase, 2),
    wage_upper = stata_round(100 * cpi_u_rs / cpibase, 2)
  )
}

#' Assemble wage from wage_noadj/weekpay/hoursu1(i), trimmed by CPI bounds.
#' (generate_wage.do, Census era Basic/ORG 1994+)
add_wage <- function(org_year, wage_bounds) {
  yr <- unique(org_year$year)
  bounds <- wage_bounds[wage_bounds$year == yr, ]

  org_year |>
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
      wage = dplyr::if_else(wage < bounds$wage_lower | wage > bounds$wage_upper, NA_real_, wage, missing = wage)
    ) |>
    dplyr::select(-wage2_adjusted)
}
