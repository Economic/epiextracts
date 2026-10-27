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
  expect_equal(recode_wbho(2010, 1, NA, 1, NA, hispanic = 1), 3)
  expect_equal(recode_wbho(2010, 1, NA, 2, NA, hispanic = 0), 2)
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
  expect_equal(recode_wbho(c(1995, 1996), 1, perace = 5, NA, NA, hispanic = c(0, 0)), c(4, NA))
  expect_equal(recode_countyfips(1995, c(8, 9), geco = 37, gtco = NA), c(NA, 37))
  expect_equal(recode_metstat(1995, c(5, 7, 9), gemetsta = 1, gtmetsta = NA), c(1, NA, 1))
})
