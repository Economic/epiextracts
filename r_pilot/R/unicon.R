# Unicon-era recodes (Basic/ORG 1976-1993): the unicon_basic source in
# variable_functions.csv. A year is wholly Unicon (before 1994) or Census
# era, and run_stage() calls these for Unicon years. Unicon columns
# come prefixed u_ (raw_unicon_month()), so they never clash with output
# names like age or hhwgt. Each function's arguments are the columns it
# reads; earnerinfo and basicfile describe the source file (read_raw_year()),
# as create_extracts.ado's $earnerinfo and $basicfile do.

# Stata's `gen x = .` with no Unicon branch: missing (string variables: "")
unicon_missing <- function(year) rep(NA_real_, length(year))
unicon_blank <- function(year) rep("", length(year))

# --- ids (generate_minsamp/hrhhid/pulineno/unicon_recnum/hhid.do) -----------
recode_minsamp_unicon <- function(u_mis) as.numeric(u_mis)
recode_hrhhid_unicon <- function(u_hhid) dplyr::coalesce(as.character(u_hhid), "")
recode_pulineno_unicon <- function(u_lineno) as.numeric(u_lineno)
recode_unicon_recnum <- function(u_recnum) as.numeric(u_recnum)

# hhid from 1984: households numbered within each month in sorted order of
# hrhhid, as Stata's gegen group(year month hrhhid) does per month file
recode_hhid_unicon <- function(year, month, hrhhid) {
  hhid <- rep(NA_real_, length(year))
  from84 <- which(year >= 1984)
  if (length(from84) > 0) {
    parts <- tibble::tibble(year, month, hrhhid)[from84, ]
    group <- vctrs::vec_rank(parts, ties = "dense", incomplete = "na")
    month_start <- stats::ave(group, parts$year, parts$month, FUN = function(g) min(g, na.rm = TRUE))
    hhid[from84] <- group - month_start + 1
  }
  hhid
}

# --- household and family, 1984+ (generate_famid/hhtype/famtype.do) ---------
from_1984 <- function(x, year) dplyr::if_else(year >= 1984, as.numeric(x), NA_real_)
recode_famid_unicon <- function(u_famnum, year) from_1984(u_famnum, year)
recode_hhtype_unicon <- function(u_hhtype, year) from_1984(u_hhtype, year)
recode_famtype_unicon <- function(u_famtyp, year) from_1984(u_famtyp, year)

# --- weights (generate_finalwgt/orgwgt/hhwgt/famwgt.do) ----------------------
# Unicon stores weights in hundredths
recode_finalwgt_unicon <- function(u_wgt) {
  finalwgt <- u_wgt / 100
  dplyr::if_else(finalwgt <= 0, NA_real_, finalwgt)
}
# earnings weight from 1979, where the file has one (basic files from 1982)
recode_orgwgt_unicon <- function(u_ernwgt, year) {
  orgwgt <- dplyr::if_else(year >= 1979, u_ernwgt / 100, NA_real_)
  dplyr::if_else(orgwgt <= 0, NA_real_, orgwgt)
}
recode_hhwgt_unicon <- function(u_hhwgt, year) dplyr::if_else(year >= 1989, u_hhwgt / 100, NA_real_)
recode_famwgt_unicon <- function(u_famwgt, year) dplyr::if_else(year >= 1984, u_famwgt / 100, NA_real_)

# --- geography (generate_statefips.do) ---------------------------------------
# From 1978 the Census state code is looked up in the geocodes. Before 1978
# Stata merges on a statefips the data doesn't have and keeps only unmatched
# rows, so the geography variables are missing (reproduced). State code 3
# in 1985m4 isn't a state: missing.
recode_statefips_unicon <- function(u_state, year, month, state_geocodes) {
  state <- dplyr::if_else(ym(year, month) == ym(1985, 4) & u_state == 3, NA_real_, as.numeric(u_state))
  statefips <- state_geocodes$statefips[match(state, state_geocodes$statecensus)]
  dplyr::if_else(year >= 1978, as.numeric(statefips), NA_real_)
}

recode_metstat_unicon <- function(u_metstat) {
  dplyr::case_when(u_metstat == 1 ~ 1, u_metstat == 2 ~ 0, TRUE ~ NA_real_)
}

# --- demographics (generate_age/female/hispanic/wbho/... .do) ----------------
recode_raw_age_unicon <- function(u_age) as.numeric(u_age)
recode_female_unicon <- function(u_sex) dplyr::case_when(u_sex == 1 ~ 0, u_sex == 2 ~ 1, TRUE ~ NA_real_)

# spneth is text ("A" = not reported) through 1988, numeric after; codes
# 1-7 are Hispanic origins. Everyone else is 0, as in Stata (gen hispanic = 0).
recode_hispanic_unicon <- function(u_spneth) {
  spneth <- suppressWarnings(as.numeric(as.character(u_spneth)))
  dplyr::if_else(!is.na(spneth) & spneth >= 1 & spneth <= 7, 1, 0)
}

# Unicon race: 1 white, 2 black, 3 other through 1988; 1989+ adds
# 3 American Indian, 4 Asian/Pacific Islander, 5 other
recode_wbho_unicon <- function(u_race, year, hispanic) {
  other_max <- dplyr::if_else(year <= 1988, 3, 5)
  race <- dplyr::case_when(
    u_race == 1 ~ 1,
    u_race == 2 ~ 2,
    u_race >= 3 & u_race <= other_max ~ 4,
    TRUE ~ NA_real_
  )
  stata_replace(race, hispanic == 1, 3)
}
# wbhao from 1989 (Asian split out)
recode_wbhao_unicon <- function(u_race, year, hispanic) {
  race <- dplyr::case_when(
    year < 1989 ~ NA_real_,
    u_race == 1 ~ 1,
    u_race == 2 ~ 2,
    u_race == 4 ~ 4,
    u_race %in% c(3, 5) ~ 5,
    TRUE ~ NA_real_
  )
  stata_replace(race, year >= 1989 & hispanic == 1, 3)
}
recode_raceorig_unicon <- function(u_race, year) {
  dplyr::case_when(
    year <= 1988 & u_race %in% c(1, 2) ~ as.numeric(u_race),
    year <= 1988 & u_race == 3 ~ 0,
    year >= 1989 & u_race >= 1 & u_race <= 4 ~ as.numeric(u_race),
    year >= 1989 & u_race == 5 ~ 0,
    TRUE ~ NA_real_
  )
}
race_only_unicon <- function(u_race, year) {
  other_max <- dplyr::if_else(year <= 1988, 3, 5)
  dplyr::case_when(
    u_race == 1 ~ "white",
    u_race == 2 ~ "black",
    u_race >= 3 & u_race <= other_max ~ "other",
    TRUE ~ NA_character_
  )
}
recode_wbo_only_unicon <- function(u_race, year) {
  unname(c(white = 1, black = 2, other = 3)[race_only_unicon(u_race, year)])
}
recode_wbho_only_unicon <- function(u_race, year, hispanic) {
  race <- unname(c(white = 1, black = 2, other = 4)[race_only_unicon(u_race, year)])
  stata_replace(race, hispanic == 1, 3)
}

# marital status: 4-5 unmarried through 1988, 4-7 from 1989
recode_married_unicon <- function(u_marstat, year) {
  unmarried_max <- dplyr::if_else(year <= 1988, 5, 7)
  dplyr::case_when(
    u_marstat >= 1 & u_marstat <= 3 ~ 1,
    u_marstat >= 4 & u_marstat <= unmarried_max ~ 0,
    TRUE ~ NA_real_
  )
}
recode_veteran_unicon <- function(u_vet) {
  dplyr::case_when(u_vet == 6 ~ 0, u_vet >= 1 & u_vet <= 5 ~ 1, TRUE ~ NA_real_)
}

# --- education (generate_gradecom/gradehi/gradeatn/educ.do) ------------------
# grade completed/highest grade through 1991; attainment (grdatn) from 1992
recode_gradecom_unicon <- function(u_grdcom, year) {
  dplyr::case_when(year <= 1991 & u_grdcom == 1 ~ 1, year <= 1991 & u_grdcom == 2 ~ 0, TRUE ~ NA_real_)
}
recode_gradehi_unicon <- function(u_grdhi, year) {
  dplyr::case_when(year <= 1988 ~ u_grdhi - 1, year <= 1991 ~ as.numeric(u_grdhi), TRUE ~ NA_real_)
}
recode_gradeatn_unicon <- function(u_grdatn, year) {
  gradeatn <- dplyr::if_else(year >= 1992, u_grdatn - 30, NA_real_)
  dplyr::if_else(gradeatn == -31, NA_real_, gradeatn)
}
recode_educ_unicon <- function(gradehi, u_grdcom, u_grdatn, year) {
  dplyr::case_when(
    year <= 1991 & gradehi == 18 ~ 5,
    year <= 1991 & (gradehi == 17 | (gradehi == 16 & u_grdcom == 1)) ~ 4,
    year <= 1991 & ((gradehi >= 13 & gradehi <= 15) | (gradehi == 16 & u_grdcom == 2)) ~ 3,
    year <= 1991 & gradehi == 12 & u_grdcom == 1 ~ 2,
    year <= 1991 & ((gradehi >= 0 & gradehi <= 11) | (gradehi == 12 & u_grdcom == 2)) ~ 1,
    year >= 1992 & u_grdatn >= 31 & u_grdatn <= 38 ~ 1,
    year >= 1992 & u_grdatn == 39 ~ 2,
    year >= 1992 & u_grdatn >= 40 & u_grdatn <= 42 ~ 3,
    year >= 1992 & u_grdatn == 43 ~ 4,
    year >= 1992 & u_grdatn >= 44 & u_grdatn <= 46 ~ 5,
    TRUE ~ NA_real_
  )
}

# --- labor force (generate_lfstat.do and the class-of-worker scripts) --------
# mlr: unemployed is 3 through 1988, 3-4 from 1989
recode_lfstat_unicon <- function(u_mlr, year) {
  unemployed_max <- dplyr::if_else(year <= 1988, 3, 4)
  dplyr::case_when(
    u_mlr >= 1 & u_mlr <= 2 ~ 1,
    u_mlr >= 3 & u_mlr <= unemployed_max ~ 2,
    u_mlr > unemployed_max & u_mlr <= 7 ~ 3,
    TRUE ~ NA_real_
  )
}

# class of worker indicators: 0 for anyone with a class, 1 for the matching one
class_indicator_unicon <- function(class, match) {
  has_class <- !is.na(class) & class >= 1
  dplyr::case_when(has_class & match ~ 1, has_class ~ 0, TRUE ~ NA_real_)
}
# self-employed: class 3 through 1988, 6 from 1989
recode_selfemp_unicon <- function(u_class, year) {
  class_indicator_unicon(u_class, u_class == dplyr::if_else(year <= 1988, 3, 6))
}
recode_selfinc_unicon <- function(u_class, year) {
  dplyr::if_else(year >= 1989, class_indicator_unicon(u_class, u_class == 5), NA_real_)
}
# public sector: class 2 through 1988, 2-4 from 1989
recode_pubsec_unicon <- function(u_class, year) {
  public <- dplyr::if_else(year <= 1988, u_class == 2, u_class >= 2 & u_class <= 4)
  class_indicator_unicon(u_class, public)
}
# federal/state/local: the 8-category class8 in 1983-1988, class from 1989
government_level_unicon <- function(u_class, u_class8, year, class8_code, class_code) {
  dplyr::case_when(
    year >= 1983 & year <= 1988 ~ class_indicator_unicon(u_class8, u_class8 == class8_code),
    year >= 1989 ~ class_indicator_unicon(u_class, u_class == class_code),
    TRUE ~ NA_real_
  )
}
recode_pubfed_unicon <- function(u_class, u_class8, year) government_level_unicon(u_class, u_class8, year, 2, 2)
recode_pubst_unicon <- function(u_class, u_class8, year) government_level_unicon(u_class, u_class8, year, 3, 3)
recode_publoc_unicon <- function(u_class, u_class8, year) government_level_unicon(u_class, u_class8, year, 4, 4)

# --- union (generate_unmem/uncov/union.do) ------------------------------------
recode_unmem_unicon <- function(u_unmem, year) {
  dplyr::if_else(year >= 1983, yes_no(u_unmem), NA_real_)
}
# coverage: 1984+ in basic files with earnings data, and 1983 in the
# separate ORG files (the basic 1983 files leave it missing)
recode_uncov_unicon <- function(u_uncov, year, earnerinfo, basicfile) {
  in_basic <- earnerinfo == 1 & basicfile == 1 & year >= 1984
  in_org <- earnerinfo == 1 & basicfile == 0 & year == 1983
  dplyr::if_else(in_basic | in_org, yes_no(u_uncov), NA_real_)
}
# as in the Census era, then missing before the years the items were asked
recode_union_unicon <- function(unmem, uncov, year, earnerinfo, basicfile) {
  union <- recode_union(unmem, uncov)
  too_early <- (earnerinfo == 1 & basicfile == 1 & year < 1984) | (earnerinfo == 1 & basicfile == 0 & year < 1983)
  dplyr::if_else(too_early, NA_real_, union)
}

# --- unemployment and work status --------------------------------------------
recode_lookdur_unicon <- function(u_wksun) nonnegative(u_wksun)
# discouraged workers from 1989: everyone 0 except dscwk == 1
recode_discwork_unicon <- function(u_dscwk, year) {
  dplyr::case_when(year < 1989 ~ NA_real_, u_dscwk %in% 1 ~ 1, TRUE ~ 0)
}
# part-time for economic reasons from 1989: work status 3 or 5 (of 2-5)
recode_ptecon_unicon <- function(u_wkstat, year) {
  dplyr::case_when(
    year < 1989 ~ NA_real_,
    u_wkstat %in% c(3, 5) ~ 1,
    u_wkstat >= 2 & u_wkstat <= 5 ~ 0,
    TRUE ~ NA_real_
  )
}

# --- hours (generate_hourslwt/hoursuorg.do) -----------------------------------
recode_hourslwt_unicon <- function(u_hours) nonnegative(u_hours)
# usual hours at the earnings job, where the file has earnings data (1979+)
recode_hoursuorg_unicon <- function(u_ernush, year, earnerinfo) {
  nonnegative(dplyr::if_else(earnerinfo == 1 & year >= 1979, as.numeric(u_ernush), NA_real_))
}

# --- industry and occupation (generate_indcode/occcode.do) --------------------
recode_indcode_unicon <- function(u_ind) as.numeric(u_ind)
recode_occcode_unicon <- function(u_occ) {
  occcode <- dplyr::if_else(u_occ >= 0, as.numeric(u_occ), NA_real_)
  dplyr::if_else(occcode < 1, NA_real_, occcode)
}

# --- earnings (generate_paidhre/weekpay_noadj/earnhour/... .do) --------------
# all need the file's earnings data ($earnerinfo); items start in 1979
earnings_era <- function(year, earnerinfo) earnerinfo == 1 & year >= 1979

recode_paidhre_unicon <- function(u__ernpdh, year, earnerinfo) {
  dplyr::if_else(earnings_era(year, earnerinfo),
                 dplyr::case_when(u__ernpdh == 2 ~ 0, u__ernpdh == 1 ~ 1, TRUE ~ NA_real_), NA_real_)
}

# weekly earnings: ernwkc through 1988 (in 1986-1988 the uncapped ernwk4x
# replaces values at the $999 cap), ernwk from 1989
recode_weekpay_noadj_unicon <- function(u_ernwkc, u_ernwk4x, u_ernwk, year, earnerinfo) {
  weekpay <- dplyr::case_when(
    !earnings_era(year, earnerinfo) ~ NA_real_,
    year <= 1988 ~ as.numeric(u_ernwkc),
    TRUE ~ as.numeric(u_ernwk)
  )
  capped <- year >= 1986 & year <= 1988 & !is.na(weekpay) & weekpay >= 999 & !is.na(u_ernwk4x) & u_ernwk4x > 999
  weekpay <- stata_replace(weekpay, capped, u_ernwk4x)
  nonnegative(weekpay)
}

# top-coded at $999 through 1988 and $1,923 in 1989-1993. The script tests
# `weekpay`, which Stata abbreviates to weekpay_noadj (see DEVIATIONS.md)
recode_tc_weekpay_unicon <- function(weekpay_noadj, year) {
  ceiling <- dplyr::if_else(year <= 1988, 999, 1923)
  dplyr::if_else(weekpay_noadj >= ceiling, 1, 0)
}

# allocation flags: through 1988 the a* flag is 1; from 1989 flags 1-8, or
# the edited value differs from the reported one (x). A missing reported
# value counts as different, as Stata compares missing as +infinity.
allocated_unicon <- function(amount, flag, edited, reported, year) {
  has_amount <- year >= 1979 & !is.na(amount) & amount > 0
  flagged <- dplyr::if_else(year <= 1988, flag %in% 1, (flag >= 1 & flag <= 8) %in% TRUE |
                              as_stata(edited) != as_stata(reported))
  dplyr::case_when(has_amount & flagged ~ 1, has_amount ~ 0, TRUE ~ NA_real_)
}
recode_a_weekpay_unicon <- function(weekpay_noadj, u_aernwk, u_ernwk, u_ernwkx, year) {
  allocated_unicon(weekpay_noadj, u_aernwk, u_ernwk, u_ernwkx, year)
}
recode_a_earnhour_unicon <- function(earnhour, u_aernhr, u_ernhr, u_ernhrx, year) {
  allocated_unicon(earnhour, u_aernhr, u_ernhr, u_ernhrx, year)
}

# hourly rate in cents
recode_earnhour_unicon <- function(u_ernhr, year, earnerinfo) {
  nonnegative(dplyr::if_else(earnings_era(year, earnerinfo), u_ernhr / 100, NA_real_))
}
# hourly top-code flag from 1989
recode_tc_earnhour_unicon <- function(earnhour, u_ernhtf, year) {
  dplyr::if_else(year >= 1989 & !is.na(earnhour), as.numeric(u_ernhtf), NA_real_)
}

# hourly wage: the rate for hourly workers; weekly earnings over usual hours
# at that job (hoursuorg) for others. Stata's x/0 is missing.
recode_wage_noadj_unicon <- function(paidhre, earnhour, weekpay_noadj, hoursuorg) {
  wage2 <- dplyr::if_else(paidhre == 0 & !is.na(hoursuorg) & hoursuorg != 0, weekpay_noadj / hoursuorg, NA_real_)
  wage2 <- dplyr::if_else(wage2 < 0, NA_real_, wage2)
  dplyr::case_when(paidhre == 1 ~ earnhour, paidhre == 0 ~ wage2, TRUE ~ NA_real_)
}

# --- family income, children, school (1984/1989+) ----------------------------
# family income categories from 1989: Unicon codes 0-5 shift up one; 19 is missing
recode_i_faminc_unicon <- function(u_faminc, year) {
  dplyr::case_when(
    year < 1989 ~ NA_real_,
    u_faminc >= 0 & u_faminc <= 5 ~ u_faminc + 1,
    u_faminc > 5 & u_faminc < 19 ~ as.numeric(u_faminc),
    TRUE ~ NA_real_
  )
}
# own children (pfnocd counts from 1) for family reference people and spouses
recode_ownchild_unicon <- function(u_pfnocd, u_famrel, year) {
  dplyr::if_else(year >= 1984 & u_famrel %in% c(1, 2) & u_pfnocd >= 1, u_pfnocd - 1, NA_real_)
}
recode_schenrl_unicon <- function(u_schenr, year) {
  dplyr::if_else(year >= 1984, yes_no(u_schenr), NA_real_)
}

# --- wage stage (adjust_wages.do), Unicon years -------------------------------
# hours imputation and the overtime-inclusive wage start in 1994
compute_hoursu1i_unicon <- function(data) {
  data$hoursu1i <- NA_real_
  data
}
add_wageotc_unicon <- function(data) {
  data$wageotc <- NA_real_
  data
}

#' wage (generate_wage.do), 1979-1993: hourly workers' wage_noadj; others'
#' top-code-adjusted weekpay over usual hours at that job (hoursuorg),
#' trimmed by the CPI bounds.
add_wage_unicon <- function(data, wage_bounds) {
  data |>
    dplyr::left_join(wage_bounds, by = "year") |>
    dplyr::mutate(
      wage2_adjusted = dplyr::if_else(paidhre == 0 & !is.na(hoursuorg) & hoursuorg != 0, weekpay / hoursuorg, NA_real_),
      wage2_adjusted = dplyr::if_else(wage2_adjusted < 0, NA_real_, wage2_adjusted),
      wage = dplyr::case_when(paidhre == 1 ~ wage_noadj, paidhre == 0 ~ wage2_adjusted, TRUE ~ NA_real_),
      wage = dplyr::if_else(wage < wage_lower | wage > wage_upper, NA_real_, wage, missing = wage)
    ) |>
    dplyr::select(-wage2_adjusted, -wage_lower, -wage_upper)
}
