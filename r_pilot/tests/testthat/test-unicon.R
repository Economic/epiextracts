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
  # March files: no earnings data ($earnerinfo 0), not basic monthly
  arrow::write_parquet(tibble::tibble(u_age = 30), file.path(dir, "march_1975_03.parquet"))
  d <- read_raw_year(file.path(dir, "march_1975_03.parquet"), "u_age")
  expect_equal(c(d$file_year, d$file_month, d$earnerinfo, d$basicfile), c(1975, 3, 0, 0))
})

test_that("March rules for the shared variables", {
  geocodes <- build_state_geocodes(file.path(repo_dir, "suppdata/state_geocodes.csv"))
  # 1962 has no geography; 1963-1967 Unicon codes to FIPS; 1968-1976 small states grouped; 1977+ Census codes
  expect_equal(recode_statefips_unicon_march(c(1, 89), c(1962, 1962), geocodes), c(NA_real_, NA_real_))
  expect_equal(recode_statefips_unicon_march(c(1, 89), c(1965, 1965), geocodes), c(23, 6))
  expect_equal(recode_statefips_unicon_march(c(19, 99, 12), rep(1970, 3), geocodes), c(101, 111, 12))
  expect_equal(recode_statefips_unicon_march(c(19, 99), c(1975, 1975), geocodes), c(112, 119))
  expect_equal(recode_statefips_unicon_march(c(11, 93), c(1990, 1990), geocodes), c(23, 6))
  expect_equal(recode_statecensus(c(101, 23), geocodes), c(101, 11))
  # 1998-2000 Census state code, then FIPS
  expect_equal(recode_statefips_census_march(c(11, 93), NA, c(1999, 1999), geocodes), c(23, 6))
  expect_equal(recode_statefips_census_march(NA, c(23, 6), c(2005, 2005), geocodes), c(23, 6))
  # metstat: citystat codes change in 1968
  expect_equal(recode_metstat_unicon_march(c(0, 1, 2), NA, rep(1965, 3)), c(1, 1, 0))
  expect_equal(recode_metstat_unicon_march(c(1, 2, 3), NA, rep(1970, 3)), c(1, 1, 0))
  # 1962 race codes go through the 1963 rules in wbho (white missing); Hispanic overrides
  expect_equal(recode_wbho_unicon_march(c(0, 1, 2), rep(1962, 3), c(0, 0, 0)), c(NA, 1, 2))
  expect_equal(recode_wbho_unicon_march(c(1, 5, 1), rep(1990, 3), c(0, 0, 1)), c(1, 4, 3))
  expect_equal(recode_raceorig_unicon_march(c(0, 1, 2), rep(1962, 3)), c(1, 2, 0))
  # wbhom: March 2012 is outside both windows
  expect_equal(recode_wbhom_census_march(c(1, 1), c(2011, 2012), c(3, 3), c(0, 0)), c(1, NA))
  # unguarded comparisons treat missing as larger than any number
  expect_equal(recode_wbo_only_census_march(c(1, 4, NA), NA, rep(2000, 3)), c(1, 3, 3))
  expect_equal(march_hours_vary(c(-4, 40, NA, -1)), c(1, 0, 0, NA))
  # hoursuorg from 1995 only in the years Stata's first record was in the earnings sample
  expect_equal(recode_hoursuorg_unicon_march(c(40, 40), c(1994, 1994)), c(40, 40))
  expect_equal(recode_hoursuorg_unicon_march(40, 1995), NA_real_)
  expect_equal(recode_hoursuorg_census_march(c(40, -4), c(2011, 2011)), c(40, NA))
  expect_equal(recode_hoursuorg_census_march(40, 2012), NA_real_)
  # educ: 1962 grdcom 6 = completed, 7 = not; 1968-1987 grdhi 1-12 first
  expect_equal(recode_educ_unicon_march(u__grdhi = c(12, 12, 18), u_grdhi = NA, u_grdcom = c(6, 7, 0),
                                        u_grdatn = NA, year = rep(1962, 3)), c(2, 1, 5))
  expect_equal(recode_educ_unicon_march(u__grdhi = c(16, 0), u_grdhi = c(5, 1), u_grdcom = c(1, 1),
                                        u_grdatn = NA, year = c(1970, 1970)), c(4, 1))
  # family income from 2019: ftot_r brackets grouped
  expect_equal(recode_i_faminc_census_march(NA, NA, NA, c(1, 3, 8, 20, 41), rep(2019, 5)), c(1, 2, 6, 11, 14))
  # reason absent: 1963-1967 codes onto the 1994 codes
  expect_equal(recode_whyabsent_unicon_march(c(1, 5), NA, c(1965, 1965)), c(5, 14))
})
