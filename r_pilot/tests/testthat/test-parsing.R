test_that("missing-data codes become NA only in decimal fields", {
  # integer fields keep -1/-2/-3 as values, like Stata's infile
  expect_equal(scale_numeric(c("5", "-1"), 0), c(5, -1))
  # decimal fields scale real values and drop negative codes
  expect_equal(scale_numeric(c("800", "-1", "  "), 2), c(8, NA, NA))
})

test_that("dictionaries parse to non-overlapping columns", {
  dict <- parse_dictionary(file.path(config$paths$dictionaries, "cpsbjun2024.dct"))
  expect_true(all(c("hrhhid", "hryear4", "pesex", "pternwa") %in% dict$varname))
  expect_false(any(duplicated(dict$varname)))
  expect_true(all(dict$end >= dict$start))
})

test_that("dictionary vintages switch on the right months", {
  expect_equal(select_dictionary(2012, 4), "cpsbjan10")
  expect_equal(select_dictionary(2012, 5), "cpsbmay12")
  expect_equal(select_dictionary(2021, 2), "cpsbjan2020")
  expect_equal(select_dictionary(2021, 3), "cpsbmar2021")
  expect_equal(select_dictionary(2030, 1), "cpsbjun2024")
  expect_equal(select_dictionary(1994, 3), "cpsbjan94")
  expect_equal(select_dictionary(1995, 8), "cpsbjun95")
  expect_equal(select_dictionary(1997, 12), "cpsbsep95")
  expect_error(select_dictionary(1993, 12), "No unique dictionary")
})

test_that("skipped months and months after the latest release are left out", {
  cfg <- list(skip_months = "2025m10", latest_year = 2026, latest_month = 9)
  expect_equal(year_months(2025, cfg), c(1:9, 11:12))
  expect_equal(year_months(2024, cfg), 1:12)
  expect_equal(year_months(2026, cfg), 1:9)
  expect_true(is_partial_year(2026, cfg))
  expect_false(is_partial_year(2025, cfg))
  expect_false(is_partial_year(2026, modifyList(cfg, list(latest_month = 12))))
})

test_that("raw zips cover the year's months, plus reweights in reweight years", {
  expect_length(raw_zip_paths(2025, config), 11)
  expect_length(raw_zip_paths(2001, config), 13)
  expect_length(raw_zip_paths(2010, config), 12)
})

test_that("NUL bytes inside records don't split lines", {
  raw <- tempfile()
  # second record's field b is all NULs, as gecmsa is in some 1994-1997 files
  writeBin(c(charToRaw("1234\n"), charToRaw("5"), as.raw(c(0, 0, 0)), charToRaw("\n")), raw)
  dict <- tibble::tibble(varname = c("a", "b"), start = c(1L, 2L), end = c(1L, 4L),
                         type = "numeric", decimals = 0L, stata_type = "int")
  parsed <- read_fwf_dictionary(raw, dict)
  expect_equal(nrow(parsed), 2)
  expect_equal(parsed$b, c(234, NA))
})
