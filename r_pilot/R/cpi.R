# CPI-U-RS: one source for the pipeline, the wage-limit table on the docs
# site, and (until cutover) the same numbers Stata uses.

#' Annual CPI-U-RS: actual values from suppdata/cpiurs_extended.csv, extended
#' past the last actual year with CBO's projected CPI-U growth
#' (config/cpi_projection.yml), rounded to 0.1 as create_extracts.ado does.
cpi_annual_fun <- function(cpi_file, projection_file) {
  cpi <- readr::read_csv(cpi_file, show_col_types = FALSE) |>
    dplyr::transmute(year = as.integer(year), cpi_u_rs = cpiurs_extended)
  cbo <- unlist(yaml::read_yaml(projection_file)$cbo_cpi_u)

  # each projected year grows from the year before by CBO's CPI-U growth
  for (y in sort(as.integer(names(cbo)))) {
    prev <- as.character(y - 1)
    if (y > max(cpi$year) && prev %in% names(cbo) && (y - 1) %in% cpi$year) {
      projected <- cpi$cpi_u_rs[cpi$year == y - 1] * cbo[[as.character(y)]] / cbo[[prev]]
      cpi <- dplyr::bind_rows(cpi, tibble::tibble(year = y, cpi_u_rs = projected))
    }
  }
  dplyr::mutate(cpi, cpi_u_rs = stata_round(cpi_u_rs, 1))
}

#' Hourly wage trimming limits: $0.50 and $100 in 1989 dollars, by year.
build_wage_bounds <- function(cpi) {
  cpibase <- cpi$cpi_u_rs[cpi$year == 1989]
  dplyr::transmute(
    cpi,
    year,
    wage_lower = stata_round(0.50 * cpi_u_rs / cpibase, 2),
    wage_upper = stata_round(100 * cpi_u_rs / cpibase, 2)
  )
}
