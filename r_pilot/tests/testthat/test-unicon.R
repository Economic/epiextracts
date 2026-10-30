test_that("each year runs one source's functions", {
  expect_equal(data_source(c(1980, 1993)), "unicon_basic")
  expect_equal(data_source(c(1994, 2026)), "census_basic")
  expect_equal(data_source(numeric(0)), "census_basic")
  expect_error(data_source(c(1993, 1994)), "mixes")
})

test_that("cached file names give the year, month and Stata's file flags", {
  dir <- tempfile(); dir.create(dir)
  arrow::write_parquet(tibble::tibble(u_age = 30), file.path(dir, "1980_02.parquet"))
  arrow::write_parquet(tibble::tibble(u_age = 40), file.path(dir, "org_1980_02.parquet"))
  arrow::write_parquet(tibble::tibble(u_age = 50), file.path(dir, "1985_02.parquet"))
  d <- read_raw_year(file.path(dir, c("1980_02.parquet", "org_1980_02.parquet", "1985_02.parquet")), "u_age")
  expect_equal(d$file_year, c(1980, 1980, 1985))
  # earnings data: separate ORG files, and basic files from 1982
  expect_equal(d$earnerinfo, c(0, 1, 1))
  expect_equal(d$basicfile, c(1, 0, 1))
})

test_that("values beyond float range are stored as missing, as Stata stores them", {
  expect_equal(stata_store(c(1.5, 1.749801e98, NA)), c(1.5, NA, NA))
  expect_equal(stata_store("a"), "a")
})

test_that("Unicon-era rules", {
  # spneth is text ("A" = not reported) through 1988
  expect_equal(recode_hispanic_unicon(c("1", "A", "8", NA)), c(1, 0, 0, 0))
  # race: 3 is other through 1988; 1989+ has 5 categories
  expect_equal(recode_wbho_unicon(c(3, 5), c(1988, 1990), hispanic = c(0, 0)), c(4, 4))
  expect_equal(recode_wbho_unicon(5, 1988, hispanic = 0), NA_real_)
  # geography is missing before 1978; state 3 in 1985m4 isn't a state
  geocodes <- tibble::tibble(statefips = c(9, 23), statecensus = c(16, 11), division = 1, region = 1)
  expect_equal(recode_statefips_unicon(c(16, 16, 3, 11), c(1977, 1978, 1985, 1985), c(1, 1, 4, 4), geocodes), c(NA, 9, NA, 23))
  # union items only in the years they were asked
  expect_equal(recode_union_unicon(unmem = c(1, 1), uncov = c(NA, NA), year = c(1983, 1984), earnerinfo = 1, basicfile = 1), c(NA, 1))
  # wage for nonhourly workers: weekly pay over hours at that job; Stata's x/0 is missing
  expect_equal(recode_wage_noadj_unicon(paidhre = c(0, 0, 1), earnhour = c(NA, NA, 8), weekpay_noadj = c(400, 400, NA),
                                        hoursuorg = c(40, 0, NA)), c(10, NA, 8))
  # allocation from 1989: flag 1-8, or the edited and reported values differ
  expect_equal(recode_a_weekpay_unicon(c(500, 500, 500), u_aernwk = c(0, 0, 3), u_ernwk = c(500, 500, 500),
                                       u_ernwkx = c(500, 499, 500), year = c(1990, 1990, 1990)), c(0, 1, 1))
})

test_that("1978-1993 files order the state columns as Stata wrote them", {
  cols <- export_columns(registry, "basic", 1985)
  expect_lt(match("statefips", cols), match("division", cols))
  expect_gt(match("statecensus", cols), match("region", cols))
  expect_equal(export_columns(registry, "basic", 1977), export_columns(registry, "basic"))
  expect_equal(export_columns(registry, "basic", 2005), export_columns(registry, "basic"))
})

test_that("May rules", {
  # May union items are coded 0 = yes; coverage starts in 1977; union missing through 1976
  expect_equal(recode_unmem_may(c(0, 1, NA)), c(1, 0, NA))
  expect_equal(recode_uncov_may(c(0, 0), c(1976, 1977)), c(NA, 1))
  expect_equal(recode_union_may(c(1, 1), c(NA, NA), c(1976, 1977)), c(NA, 1))
  # paid hourly: hourpd (0 = yes) through 1978, _ernpdh after
  expect_equal(recode_paidhre_may(c(0, NA), c(NA, 1), c(1978, 1979)), c(1, 1))
  # 1980 May earnings are missing; earlier nonhourly wages use the May hours question
  expect_equal(recode_weekpay_noadj_may(c(NA, NA), c(500, 500), c(1980, 1981)), c(NA, 500))
  expect_equal(recode_wage_noadj_may(paidhre = c(0, 0, 1), earnhour = c(NA, NA, 5), weekpay_noadj = c(400, 400, NA),
                                     hoursumay = c(40, NA, NA), hoursuorg = c(NA, 20, NA), year = c(1977, 1981, 1980)),
               c(10, 20, NA))
  # May files are supplement files: earnings data, not basic monthly
  dir <- tempfile(); dir.create(dir)
  arrow::write_parquet(tibble::tibble(u_age = 30), file.path(dir, "may_1975_05.parquet"))
  d <- read_raw_year(file.path(dir, "may_1975_05.parquet"), "u_age")
  expect_equal(c(d$file_year, d$file_month, d$earnerinfo, d$basicfile), c(1975, 5, 1, 0))
})
