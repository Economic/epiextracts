cpi <- cpi_annual_fun(file.path(config$paths$suppdata, "cpiurs_extended.csv"),
                      file.path(repo_dir, "config/cpi_projection.yml"))

test_that("actual CPI-U-RS values pass through and later years are projected", {
  csv <- readr::read_csv(file.path(config$paths$suppdata, "cpiurs_extended.csv"), show_col_types = FALSE)
  expect_equal(cpi$cpi_u_rs[cpi$year %in% csv$year], stata_round(csv$cpiurs_extended, 1))
  # one projected year per CBO level past the last actual year
  expect_equal(max(cpi$year), max(csv$year) + 1)
})

test_that("wage limits match create_extracts.ado's table", {
  bounds <- build_wage_bounds(cpi)
  # values from documentation/docs/misc/extremewages.csv (Stata)
  expect_equal(bounds$wage_lower[bounds$year == 1989], 0.50)
  expect_equal(bounds$wage_upper[bounds$year == 1962], 26.98)
  expect_equal(bounds$wage_upper[bounds$year == 2026], 260.22)
})

test_that("config and release metadata resolve", {
  expect_true(dir.exists(config$paths$dictionaries))
  # the year range ends at the latest month in release.yml
  latest <- yaml::read_yaml(file.path(repo_dir, "config/release.yml"))$latestdata
  expect_equal(max(config$years), as.integer(substr(latest, 1, 4)))
  expect_match(data_label("basic", file.path(repo_dir, "config/release.yml")),
               "^EPI CPS Basic Monthly Extracts, Version [0-9]{4}\\.[0-9]+\\.[0-9]+$")
})
