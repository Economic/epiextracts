# Ids, weights, labor force and earnings recodes (Census era, Basic/ORG).
# Each function's arguments are the columns it reads; see R/registry.R.

# --- ids and dates (generate_year/month/hrhhid/hhid/personid/pulineno.do) --
# year and month come from the file's date, as in Stata (1994-1997 files only
# have a 2-digit hryear)
recode_survey_year <- function(file_year) as.numeric(file_year)
recode_survey_month <- function(file_month) as.numeric(file_month)
recode_hrhhid <- function(hrhhid) hrhhid
recode_pulineno <- function(pulineno) as.numeric(pulineno)

# hhid: qstnum from 1998. For 1994-1997 Stata numbers households within each
# month file with gegen group(year month gestfips hrhhid huhhnum hrsample
# hrsersuf): ids 1, 2, ... in sorted order of those parts (strings sorted
# bytewise, as Stata does).
recode_hhid <- function(qstnum, year, month, gestfips, hrhhid, huhhnum, hrsample, hrsersuf) {
  hhid <- as.numeric(qstnum)
  pre98 <- which(year <= 1997)
  if (length(pre98) > 0) {
    parts <- tibble::tibble(year, month, gestfips, hrhhid, huhhnum, hrsample, hrsersuf)[pre98, ]
    # group ids across all months in sorted order; groups of a month are contiguous
    group <- vctrs::vec_rank(parts, ties = "dense", incomplete = "na")
    month_start <- stats::ave(group, parts$year, parts$month, FUN = function(g) min(g, na.rm = TRUE))
    hhid[pre98] <- group - month_start + 1
  }
  hhid
}

# personid: occurnum from 1998; missing before (no person id in 1994-1997 files)
recode_personid <- function(occurnum) as.numeric(occurnum)

# --- age (generate_age.do) --------------------------------------------------
# peage covers 1994m1-2012m4, prtage covers 2012m5+; the two never co-occur
# within a given row, so coalesce() picks whichever is populated.
recode_raw_age <- function(peage, prtage) {
  dplyr::coalesce(as.numeric(peage), as.numeric(prtage))
}

recode_age <- function(raw_age) {
  age <- dplyr::if_else(raw_age < 0, NA_real_, raw_age)  # missing if age < 0
  dplyr::if_else(age >= 80, 80, age)                     # top-code at 80 ("80+")
}

# --- female (generate_female.do), Census era Basic Monthly -----------------
recode_female <- function(pesex) {
  dplyr::case_when(
    pesex == 1 ~ 0,
    pesex == 2 ~ 1,
    TRUE       ~ NA_real_
  )
}

# --- lfstat (generate_lfstat.do), Census era Basic Monthly 1998+ -----------
recode_lfstat <- function(pemlr) {
  pemlr <- as.numeric(pemlr)
  dplyr::case_when(
    pemlr >= 1 & pemlr <= 2 ~ 1,  # employed
    pemlr >= 3 & pemlr <= 4 ~ 2,  # unemployed
    pemlr >= 5 & pemlr <= 7 ~ 3,  # NILF
    TRUE                    ~ NA_real_
  )
}

# --- emp (generate_emp.do) --------------------------------------------------
recode_emp <- function(lfstat) {
  dplyr::case_when(
    !is.na(lfstat) & lfstat == 1 ~ 1,
    !is.na(lfstat)               ~ 0,
    TRUE                         ~ NA_real_
  )
}

# --- cmpwgt (generate_cmpwgt.do), 1998+ -------------------------------------
# Census-2000-based reweighted series (nwcmpwgt) supersedes pwcmpwgt for
# 2000-2002 only; nwcmpwgt is absent/NA outside that window by construction.
recode_cmpwgt <- function(pwcmpwgt, nwcmpwgt, year, reweight_years) {
  cmpwgt <- dplyr::if_else(
    year %in% reweight_years,
    as.numeric(nwcmpwgt),
    as.numeric(pwcmpwgt)
  )
  dplyr::if_else(cmpwgt <= 0, NA_real_, cmpwgt)
}

# --- finalwgt (generate_finalwgt.do), Census era Basic Monthly 1994+ -------
# Census-2000-based nwsswgt replaces pwsswgt in the reweight years.
recode_finalwgt <- function(pwsswgt, nwsswgt, year, reweight_years) {
  finalwgt <- dplyr::if_else(year %in% reweight_years, as.numeric(nwsswgt), as.numeric(pwsswgt))
  dplyr::if_else(finalwgt <= 0, NA_real_, finalwgt)
}

# --- basicwgt (generate_basicwgt.do), Census era Basic Monthly 1994+ -------
# finalwgt through 1997, cmpwgt from 1998. Age floor uses the RAW
# (untopcoded) age variable, not the generated `age`.
recode_basicwgt <- function(cmpwgt, finalwgt, raw_age, year) {
  basicwgt <- dplyr::if_else(year <= 1997, finalwgt, cmpwgt)
  dplyr::if_else(raw_age < 16 | is.na(raw_age), NA_real_, basicwgt)
}

# --- minsamp (generate_minsamp.do), Census era Basic Monthly 1994+ ---------
recode_minsamp <- function(hrmis) as.numeric(hrmis)

# --- orgwgt (generate_orgwgt.do), Census era Basic Monthly 1994+ -----------
# Same reweight-era pattern as cmpwgt: nworwgt supersedes pworwgt for 2000-2002.
recode_orgwgt <- function(pworwgt, nworwgt, year, reweight_years) {
  orgwgt <- dplyr::if_else(
    year %in% reweight_years,
    as.numeric(nworwgt),
    as.numeric(pworwgt)
  )
  dplyr::if_else(orgwgt <= 0 | is.na(orgwgt), NA_real_, orgwgt)
}

# --- paidhre (generate_paidhre.do), Census era Basic Monthly 1994+ --------
recode_paidhre <- function(peernhry) {
  dplyr::case_when(
    peernhry == 2 ~ 0,
    peernhry == 1 ~ 1,
    TRUE          ~ NA_real_
  )
}

# --- hoursu1 (generate_hoursu1.do), Census era Basic Monthly 1994+ --------
recode_hoursu1 <- function(pehrusl1) {
  hoursu1 <- as.numeric(pehrusl1)
  dplyr::if_else(hoursu1 < 0, NA_real_, hoursu1)
}

# --- hoursvary1 (generate_hoursvary1.do): pehrusl1 == -4 is the "hours
# vary" sentinel value -----------------------------------------------------
recode_hoursvary1 <- function(pehrusl1) {
  dplyr::case_when(
    pehrusl1 == -4 ~ 1,
    pehrusl1 >= 0  ~ 0,
    TRUE           ~ NA_real_
  )
}

# --- hoursuint (generate_hoursuint.do): interval-coded usual hours (1-8) --
recode_hoursuint <- function(prhrusl) {
  hoursuint <- as.numeric(prhrusl)
  dplyr::if_else(hoursuint < 1, NA_real_, hoursuint)
}

# --- hoursuorg (generate_hoursuorg.do): backfilled with hoursu1 for ORG
# rotations when peernhro is missing/non-positive --------------------------
recode_hoursuorg <- function(peernhro, hoursu1, minsamp) {
  raw <- as.numeric(peernhro)
  hoursuorg <- dplyr::if_else(
    (is.na(raw) | raw <= 0) & (minsamp == 4 | minsamp == 8),
    hoursu1,
    raw
  )
  dplyr::if_else(hoursuorg < 0, NA_real_, hoursuorg)
}

# --- earnhour (generate_earnhour.do): hourly workers' reported rate ------
# prernhly (...-2021m2) / pternhly (2021m3+), raw column renamed mid-2021.
recode_earnhour <- function(year, month, prernhly, pternhly) {
  earnhour <- dplyr::if_else(
    year < 2021 | (year == 2021 & month <= 2),
    as.numeric(prernhly),
    as.numeric(pternhly)
  )
  dplyr::if_else(earnhour < 0, NA_real_, earnhour)
}

# --- weekpay_noadj (generate_weekpay_noadj.do): raw weekly earnings ------
# prernwa (...-2021m2) / pternwa (2021m3+), same rename boundary as earnhour.
recode_weekpay_noadj <- function(year, month, prernwa, pternwa) {
  weekpay_noadj <- dplyr::if_else(
    year < 2021 | (year == 2021 & month <= 2),
    as.numeric(prernwa),
    as.numeric(pternwa)
  )
  dplyr::if_else(weekpay_noadj < 0, NA_real_, weekpay_noadj)
}

# --- wage_noadj (generate_wage_noadj.do) -----------------------------------
# earnhour for hourly workers; weekpay_noadj/hoursu1 for nonhourly. Guard
# div-by-zero/NA explicitly -- Stata's x/0 is missing, R's is Inf.
recode_wage_noadj <- function(paidhre, earnhour, weekpay_noadj, hoursu1) {
  wage2 <- dplyr::if_else(
    paidhre == 0 & !is.na(hoursu1) & hoursu1 > 0,
    weekpay_noadj / hoursu1,
    NA_real_
  )
  wage2 <- dplyr::if_else(wage2 < 0, NA_real_, wage2, missing = wage2)
  dplyr::if_else(paidhre == 1, earnhour, wage2)
}

# --- ptwk: BLS top-code flag for weekly earnings, 2023m4+ (raw, used by add_weekpay)
recode_ptwk <- function(ptwk) as.numeric(ptwk)
