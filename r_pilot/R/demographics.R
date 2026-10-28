# Demographic, education, family and disability recodes (Census era, Basic/ORG).
# Each function's arguments are the columns it reads; see R/registry.R.

# --- educ (generate_educ.do), 1994+ ----------------------------------------
recode_educ <- function(peeduca) {
  dplyr::case_when(
    peeduca >= 31 & peeduca <= 38 ~ 1,
    peeduca == 39                 ~ 2,
    peeduca >= 40 & peeduca <= 42 ~ 3,
    peeduca == 43                 ~ 4,
    peeduca >= 44 & peeduca <= 46 ~ 5,
    TRUE                          ~ NA_real_
  )
}

# --- hispanic (generate_hispanic.do), 1994+ --------------------------------
# Baseline 0 (never missing), matching Stata's `gen hispanic = 0` then
# replace-to-1 pattern -- source column renamed 1994-2002 -> 2003+.
recode_hispanic <- function(year, prorigin, prdthsp) {
  dplyr::case_when(
    year <= 2002                   ~ dplyr::if_else(!is.na(prorigin) & prorigin >= 1 & prorigin <= 7, 1, 0),
    year >= 2003 & year <= 2013    ~ dplyr::if_else(!is.na(prdthsp) & prdthsp >= 1 & prdthsp <= 5, 1, 0),
    year >= 2014                   ~ dplyr::if_else(!is.na(prdthsp) & prdthsp >= 1 & prdthsp <= 8, 1, 0),
    TRUE                           ~ 0
  )
}

# --- ptdtrace: detailed race, 2003+ -----------------------------------------
# Census renamed it prdtrace for May 2004-Jul 2005; generate_wbho.do creates
# ptdtrace from it there, and every race variable after wbho reads ptdtrace.
recode_ptdtrace <- function(ptdtrace, prdtrace) {
  dplyr::coalesce(as.numeric(ptdtrace), as.numeric(prdtrace))
}

# Detailed-race eras: 2003m1-2012m4 (21 codes) and 2012m5+ (26 codes)
race_era <- function(year, month) {
  dplyr::case_when(
    year <= 2002 ~ "perace",
    ym(year, month) <= ym(2012, 4) ~ "dtrace03",
    TRUE ~ "dtrace12"
  )
}

# --- wbho (generate_wbho.do), 1994+ ----------------------------------------
# Race source column/coding changes at 1996, 2003 and again at 2012m5.
# Hispanic ethnicity always overrides.
recode_wbho <- function(year, month, perace, ptdtrace, hispanic) {
  ptdtrace_eff <- ptdtrace
  is_pre2003    <- year <= 2002
  is_2003_2012a <- year >= 2003 & (year < 2012 | (year == 2012 & month <= 4))
  is_2012b_on   <- year > 2012 | (year == 2012 & month >= 5)
  # perace has a fifth category (other) in 1994-1995 only
  other_max <- dplyr::if_else(year <= 1995, 5, 4)

  race <- dplyr::case_when(
    is_pre2003 & perace == 1 ~ 1,
    is_pre2003 & perace == 2 ~ 2,
    is_pre2003 & perace >= 3 & perace <= other_max ~ 4,

    is_2003_2012a & ptdtrace_eff == 1 ~ 1,
    is_2003_2012a & (ptdtrace_eff == 2 | ptdtrace_eff %in% c(6, 10, 11, 12, 15, 16, 19)) ~ 2,
    is_2003_2012a & ((ptdtrace_eff >= 3 & ptdtrace_eff <= 5) |
                       ptdtrace_eff %in% c(7, 8, 9, 13, 14, 17, 18, 20, 21)) ~ 4,

    is_2012b_on & ptdtrace_eff == 1 ~ 1,
    is_2012b_on & (ptdtrace_eff == 2 | ptdtrace_eff %in% c(6, 10, 11, 12, 16, 17, 18, 22, 23)) ~ 2,
    is_2012b_on & ((ptdtrace_eff >= 3 & ptdtrace_eff <= 5) |
                     ptdtrace_eff %in% c(7, 8, 9, 13, 14, 15, 19, 20, 21, 24, 25, 26)) ~ 4,

    TRUE ~ NA_real_
  )
  dplyr::if_else(hispanic == 1, 3, race, missing = race)
}

# --- wbhao (generate_wbhao.do): wbho with Asian (4) split from other (5) ----
recode_wbhao <- function(year, month, perace, ptdtrace, hispanic) {
  era <- race_era(year, month)
  race <- dplyr::case_when(
    era == "perace" & perace == 1 ~ 1,
    era == "perace" & perace == 2 ~ 2,
    era == "perace" & perace == 4 ~ 4,
    era == "perace" & perace %in% c(3, 5) ~ 5,

    era == "dtrace03" & ptdtrace == 1 ~ 1,
    era == "dtrace03" & ptdtrace %in% c(2, 6, 10, 11, 12, 15, 16, 19) ~ 2,
    era == "dtrace03" & ptdtrace %in% c(4, 5, 8, 9, 13, 14, 17, 18) ~ 4,
    era == "dtrace03" & ptdtrace %in% c(3, 7, 20, 21) ~ 5,

    era == "dtrace12" & ptdtrace == 1 ~ 1,
    era == "dtrace12" & ptdtrace %in% c(2, 6, 10, 11, 12, 16, 17, 18, 22, 23) ~ 2,
    era == "dtrace12" & ptdtrace %in% c(4, 5, 8, 9, 13, 14, 15, 19, 20, 21, 24) ~ 4,
    era == "dtrace12" & ptdtrace %in% c(3, 7, 25, 26) ~ 5,
    TRUE ~ NA_real_
  )
  stata_replace(race, hispanic == 1, 3)
}

# --- wbhom (generate_wbhom.do): multiple races (5) apart, 2003+ -------------
# AI-Asian, Asian-HP (and AI-HP from 2012m5) count as other, not multiple
recode_wbhom <- function(year, month, ptdtrace, hispanic) {
  era <- race_era(year, month)
  last_code <- dplyr::if_else(era == "dtrace12", 26, 21)
  other_pairs <- dplyr::if_else(era == "dtrace12", ptdtrace %in% c(13, 14, 15), ptdtrace %in% c(13, 14))
  race <- dplyr::case_when(
    era == "perace" ~ NA_real_,
    other_pairs ~ 4,
    ptdtrace == 1 ~ 1,
    ptdtrace == 2 ~ 2,
    ptdtrace >= 3 & ptdtrace <= 5 ~ 4,
    ptdtrace >= 6 & ptdtrace <= last_code ~ 5,
    TRUE ~ NA_real_
  )
  stata_replace(race, era != "perace" & hispanic == 1, 3)
}

# --- wbhaom (generate_wbhaom.do): Asian, Native American and multiple, 2003+
recode_wbhaom <- function(year, month, ptdtrace, hispanic) {
  era <- race_era(year, month)
  last_code <- dplyr::if_else(era == "dtrace12", 26, 21)
  race <- dplyr::case_when(
    era == "perace" ~ NA_real_,
    ptdtrace == 1 ~ 1,
    ptdtrace == 2 ~ 2,
    ptdtrace %in% c(4, 5) ~ 4,
    ptdtrace == 3 ~ 5,
    ptdtrace >= 6 & ptdtrace <= last_code ~ 6,
    TRUE ~ NA_real_
  )
  stata_replace(race, era != "perace" & hispanic == 1, 3)
}

# --- raceorig (generate_raceorig.do): race, minimally recoded --------------
# 1994-2002 perace codes 1-4 (5 = other, 0, through 1995); 2003+ detailed
# codes mapped onto one combined list (see value_labels.csv)
raceorig_dtrace03 <- c(1, 2, 3, 5, 6, 10:23, 30, 31)
raceorig_dtrace12 <- c(1, 2, 3, 5, 6, 10:17, 24, 18:20, 25, 21, 26, 22, 27, 23, 28, 30, 31)
recode_raceorig <- function(year, month, perace, ptdtrace) {
  era <- race_era(year, month)
  dplyr::case_when(
    era == "perace" & perace >= 1 & perace <= 4 ~ as.numeric(perace),
    era == "perace" & perace == 5 & year <= 1995 ~ 0,
    era == "dtrace03" & ptdtrace >= 1 & ptdtrace <= 21 ~ raceorig_dtrace03[pmin(pmax(ptdtrace, 1), 21)],
    era == "dtrace12" & ptdtrace >= 1 & ptdtrace <= 26 ~ raceorig_dtrace12[pmin(pmax(ptdtrace, 1), 26)],
    TRUE ~ NA_real_
  )
}

# --- wbo_only / wbho_only (generate_wbo_only.do, generate_wbho_only.do) -----
# single-race white and black; everyone else other. perace 5 is other only
# through 1995, as in wbho.
race_only <- function(year, month, perace, ptdtrace) {
  era <- race_era(year, month)
  perace_max <- dplyr::if_else(year <= 1995, 5, 4)
  dtrace_max <- dplyr::if_else(era == "dtrace12", 26, 21)
  code <- dplyr::if_else(era == "perace", as.numeric(perace), ptdtrace)
  top <- dplyr::if_else(era == "perace", perace_max, dtrace_max)
  dplyr::case_when(
    code == 1 ~ "white",
    code == 2 ~ "black",
    code >= 3 & code <= top ~ "other",
    TRUE ~ NA_character_
  )
}
recode_wbo_only <- function(year, month, perace, ptdtrace) {
  c(white = 1, black = 2, other = 3)[race_only(year, month, perace, ptdtrace)] |> unname()
}
recode_wbho_only <- function(year, month, perace, ptdtrace, hispanic) {
  race <- c(white = 1, black = 2, other = 4)[race_only(year, month, perace, ptdtrace)] |> unname()
  stata_replace(race, hispanic == 1, 3)
}

# --- citistat (generate_citistat.do), 1994+ --------------------------------
recode_citistat <- function(prcitshp) as.numeric(prcitshp)

# --- citizen (generate_citizen.do): citistat 1-4 are citizens ---------------
recode_citizen <- function(citistat) {
  citizen <- dplyr::if_else(!is.na(citistat), 0, NA_real_)
  stata_replace(citizen, citistat >= 1 & citistat <= 4, 1)
}

# --- veteran (generate_veteran.do): peafwhen 1994m12-2005m7, then peafever/peafwhn1
recode_veteran <- function(year, month, peafwhen, peafever, peafwhn1) {
  date <- ym(year, month)
  old <- date >= ym(1994, 12) & date <= ym(2005, 7)
  new <- date >= ym(2005, 8)
  veteran <- rep(NA_real_, length(year))
  veteran <- stata_replace(veteran, old & peafwhen == 6, 0)
  veteran <- stata_replace(veteran, old & peafwhen >= 1 & peafwhen <= 5, 1)
  veteran <- stata_replace(veteran, new & peafever == 2, 0)
  stata_replace(veteran, new & peafwhn1 >= 1 & peafwhn1 <= 9, 1)
}

# --- gradeatn (generate_gradeatn.do): peeduca shifted to 1-16 ---------------
# only "not in universe" (-1) is set missing; other negative codes stay shifted
recode_gradeatn <- function(peeduca) {
  gradeatn <- as.numeric(peeduca) - 30
  dplyr::if_else(gradeatn == -31, NA_real_, gradeatn)
}

# --- schenrl (generate_schenrl.do) -------------------------------------------
recode_schenrl <- function(peschenr) yes_no(peschenr)

# --- family (generate_famrel/ownchild/agechild.do) ---------------------------
recode_famrel <- function(prfamrel) nonnegative(prfamrel)

# own children counted for family reference people and spouses, from 1999m11
recode_ownchild <- function(year, month, prnmchld, prfamrel) {
  from <- ym(year, month) >= ym(1999, 11)
  dplyr::if_else(from & prfamrel %in% c(1, 2) & prnmchld >= 0, as.numeric(prnmchld), NA_real_)
}
recode_agechild <- function(year, month, prchld) {
  nonnegative(in_window(prchld, year, month, from = c(1999, 11)))
}

# --- family income (generate_i_faminc.do, generate_i_faminc_det.do) ---------
# hufaminc through 2009, hefaminc from 2010. Codes above 12 shift down one,
# collapsing $50,000-59,999 and $60,000-74,999 into one category.
recode_i_faminc <- function(year, hufaminc, hefaminc) {
  raw <- dplyr::if_else(year <= 2009, as.numeric(hufaminc), as.numeric(hefaminc))
  dplyr::case_when(
    raw >= 0 & raw <= 12 ~ raw,
    raw > 12 ~ raw - 1,
    TRUE ~ NA_real_
  )
}
recode_i_faminc_det <- function(year, hefaminc) {
  dplyr::if_else(year >= 2010, as.numeric(hefaminc), NA_real_)
}

# --- disability (generate_diff*.do, generate_difficulty.do), 2009+ ----------
recode_diffdress <- function(year, pedisdrs) dplyr::if_else(year >= 2009, yes_no(pedisdrs), NA_real_)
recode_differrands <- function(year, pedisout) dplyr::if_else(year >= 2009, yes_no(pedisout), NA_real_)
recode_diffhear <- function(year, pedisear) dplyr::if_else(year >= 2009, yes_no(pedisear), NA_real_)
recode_diffmemory <- function(year, pedisrem) dplyr::if_else(year >= 2009, yes_no(pedisrem), NA_real_)
recode_diffphysical <- function(year, pedisphy) dplyr::if_else(year >= 2009, yes_no(pedisphy), NA_real_)
recode_diffvision <- function(year, pediseye) dplyr::if_else(year >= 2009, yes_no(pediseye), NA_real_)
recode_difficulty <- function(year, prdisflg) dplyr::if_else(year >= 2009, yes_no(prdisflg), NA_real_)

# --- married (generate_married.do), 1994+ ----------------------------------
recode_married <- function(prmarsta) {
  dplyr::case_when(
    prmarsta >= 4 & prmarsta <= 7 ~ 0,
    prmarsta >= 1 & prmarsta <= 3 ~ 1,
    TRUE                          ~ NA_real_
  )
}

# --- statefips (generate_statefips.do), 1994+ ------------------------------
# statecensus/division/region are looked up from it in R/geography.R.
recode_statefips <- function(gestfips) as.numeric(gestfips)

# --- unmem/uncov/union (generate_unmem.do, generate_uncov.do,
# generate_union.do), 1994+, ORG-supplement questions (earnerinfo==1) -------
# IMPORTANT: dplyr::if_else()'s default NA-propagation does NOT match Stata's
# `replace x = y if cond` (which leaves x unchanged when cond is missing/false)
# -- every sequential replace-if here MUST pass missing = <current value>,
# or NA condition values silently corrupt rows instead of leaving them as-is.
recode_unmem <- function(peernlab) {
  dplyr::case_when(peernlab == 2 ~ 0, peernlab == 1 ~ 1, TRUE ~ NA_real_)
}

recode_uncov <- function(peerncov) {
  dplyr::case_when(peerncov == 2 ~ 0, peerncov == 1 ~ 1, TRUE ~ NA_real_)
}

recode_union <- function(unmem, uncov) {
  union <- dplyr::case_when(!is.na(unmem) | !is.na(uncov) ~ 0, TRUE ~ NA_real_)
  union <- dplyr::if_else(unmem == 1, 1, union, missing = union)
  union <- dplyr::if_else(uncov == 1, 1, union, missing = union)
  union
}

# --- pubsec (generate_pubsec.do), 1994+ ------------------------------------
recode_pubsec <- function(peio1cow) {
  pubsec <- dplyr::case_when(peio1cow >= 1 & !is.na(peio1cow) ~ 0, TRUE ~ NA_real_)
  dplyr::if_else(peio1cow >= 1 & peio1cow <= 3, 1, pubsec, missing = pubsec)
}
