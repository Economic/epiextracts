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
  # 1994-1997 vintages are not in the table yet
  expect_error(select_dictionary(1997, 6), "No unique dictionary")
})

test_that("skipped months are left out", {
  expect_equal(year_months(2025, "2025m10"), c(1:9, 11:12))
  expect_equal(year_months(2024, "2025m10"), 1:12)
})

test_that("raw zips include the reweight archive only in reweight years", {
  expect_length(raw_zip_paths(2001, config), 13)
  expect_length(raw_zip_paths(2010, config), 12)
})
