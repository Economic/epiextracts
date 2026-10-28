test_that("stata_round rounds half away from zero", {
  # base R would give 0, 2, 2, -0 (round half to even)
  expect_equal(stata_round(c(0.5, 1.5, 2.5, -0.5)), c(1, 2, 3, -1))
  expect_equal(stata_round(2.345, 2), 2.35)
})

test_that("age is top-coded at 80 and negative raw ages are missing", {
  expect_equal(recode_age(c(-1, 15, 80, 85)), c(NA, 15, 80, 80))
  expect_equal(recode_raw_age(c(30, NA), c(NA, 45)), c(30, 45))
})

test_that("union follows Stata's replace-if semantics with missing values", {
  # a missing unmem must not wipe out coverage
  expect_equal(recode_union(unmem = c(1, 0, NA, NA), uncov = c(NA, 1, 0, NA)), c(1, 1, 0, NA))
})

test_that("hispanic overrides race in wbho", {
  expect_equal(recode_wbho(2010, 1, NA, 1, hispanic = 1), 3)
  expect_equal(recode_wbho(2010, 1, NA, 2, hispanic = 0), 2)
})

test_that("wage_noadj guards against zero hours", {
  expect_equal(recode_wage_noadj(paidhre = c(0, 0, 1), earnhour = c(NA, NA, 12),
                                 weekpay_noadj = c(800, 800, NA), hoursu1 = c(40, 0, NA)),
               c(20, NA, 12))
})

test_that("basicwgt uses raw age and orgwgt uses reweights in reweight years", {
  expect_equal(recode_basicwgt(cmpwgt = c(100, 100), finalwgt = c(50, 50), raw_age = c(15, 16), year = c(2001, 2001)), c(NA, 100))
  # finalwgt before 1998
  expect_equal(recode_basicwgt(cmpwgt = NA, finalwgt = 50, raw_age = 30, year = 1997), 50)
  expect_equal(recode_orgwgt(pworwgt = 10, nworwgt = 20, year = c(2001, 2003), reweight_years = 2000:2002), c(20, 10))
})

test_that("state lookups match the geocode file", {
  geocodes <- build_state_geocodes(file.path(config$paths$suppdata, "state_geocodes.csv"))
  expect_equal(recode_region(c(6, 36, 99), geocodes), c(4, 1, NA))
})

test_that("1994-1997 hhid numbers households within each month in sorted order", {
  hhid <- recode_hhid(qstnum = rep(NA, 5), year = rep(1995, 5), month = c(1, 1, 1, 2, 2),
                      gestfips = c(6, 1, 6, 6, 6), hrhhid = c("b", "z", "a", "a", "a"),
                      huhhnum = rep(1, 5), hrsample = rep("A1", 5), hrsersuf = c("", "", "", "", "-"))
  expect_equal(hhid, c(3, 1, 2, 1, 2))
  # 1998 on: qstnum
  expect_equal(recode_hhid(qstnum = "123", year = 1998, month = 1, gestfips = 6,
                           hrhhid = "a", huhhnum = 1, hrsample = "A1", hrsersuf = ""), 123)
})

test_that("era rules for 1994-1997", {
  # perace 5 is "other" only through 1995
  expect_equal(recode_wbho(c(1995, 1996), 1, perace = 5, NA, hispanic = c(0, 0)), c(4, NA))
  expect_equal(recode_countyfips(1995, c(8, 9), geco = 37, gtco = NA), c(NA, 37))
  expect_equal(recode_metstat(1995, c(5, 7, 9), gemetsta = 1, gtmetsta = NA), c(1, NA, 1))
})

test_that("Stata missing-value semantics", {
  # replace ... if <missing condition> leaves the value alone
  expect_equal(stata_replace(c(1, 2, 3), c(TRUE, NA, FALSE), 9), c(9, 2, 3))
  # an unguarded x >= 0 is true for missing x: missing hours count as "do not vary"
  expect_equal(hours_vary(c(-4, 40, NA, -1)), c(1, 0, 0, NA))
})

test_that("race variants follow each era's detailed race codes", {
  # prdtrace fills ptdtrace in May 2004-Jul 2005
  expect_equal(recode_ptdtrace(c(NA, 4), c(7, NA)), c(7, 4))
  # AI-HP (14) is Asian in wbhao and other (not multiple) in wbhom from 2012m5
  expect_equal(recode_wbhao(2015, 1, NA, 14, hispanic = 0), 4)
  expect_equal(recode_wbhom(2015, 1, 14, hispanic = 0), 4)
  expect_equal(recode_wbhom(2011, 1, 14, hispanic = 0), 4)
  expect_equal(recode_wbhom(2011, 1, 15, hispanic = 0), 5)
  # raceorig maps 2012m5+ codes onto the combined list
  expect_equal(recode_raceorig(2015, 1, NA, c(14, 15, 18, 26)), c(24, 18, 25, 31))
  expect_equal(recode_raceorig(c(1995, 1996), 1, c(5, 5), NA), c(0, NA))
})

test_that("mocc10 takes the last matching range in script order", {
  crosswalk <- tibble::tibble(from = ym(2020, 1), to = Inf, step = 1:2, mocc10 = c(1, 2),
                              low = c(10, 15), high = c(20, 30))
  expect_equal(recode_mocc10(c(12, 17, 25, NA), 2021, 1, crosswalk), c(1, 2, 2, NA))
  expect_equal(recode_mocc10(17, 2019, 12, crosswalk), NA_real_)
})

test_that("earnings flags use weekpay_noadj, as Stata's abbreviation does", {
  # fixed ceiling before 2023m4, then the BLS flag (only where weekpay_noadj exists)
  expect_equal(recode_tc_weekpay(c(2884.61, 100, NA), ptwk = c(0, 1, 1), year = 2020, month = 1), c(1, 0, NA))
  expect_equal(recode_tc_weekpay(c(2884.61, 100, NA), ptwk = c(0, 1, 1), year = 2023, month = 4), c(0, 1, NA))
  expect_equal(recode_tc_weekpay(1923, ptwk = NA, year = 1997, month = 1), 1)
  # overtime per hour is added for hourly workers who report it
  expect_equal(recode_wageotc_noadj(paidhre = c(1, 1, 0), earnhour = c(10, 10, NA), otcrec = c(1, 0, NA),
                                    otcamt = c(40, NA, NA), peernhro = c(20, 20, NA), hoursuorg = c(20, 20, NA),
                                    wage_noadj = c(10, 10, 25)), c(12, 10, 25))
})
