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

# --- raw household ids for joining back to Census files ---------------------
# (generate_hrhhid2/hrsample/hrsersuf/huhhnum.do). Strings are "" where not
# available, as in Stata. hrhhid2 starts 2004m5; the other three end 2004m4.
recode_hrhhid2 <- function(hrhhid2, year, month) {
  dplyr::if_else(ym(year, month) >= ym(2004, 5), dplyr::coalesce(as.character(hrhhid2), ""), "")
}
recode_hrsample <- function(hrsample, year, month) {
  dplyr::if_else(ym(year, month) <= ym(2004, 4), dplyr::coalesce(as.character(hrsample), ""), "")
}
recode_hrsersuf <- function(hrsersuf, year, month) {
  dplyr::if_else(ym(year, month) <= ym(2004, 4), dplyr::coalesce(as.character(hrsersuf), ""), "")
}
recode_huhhnum <- function(huhhnum, year, month) in_window(huhhnum, year, month, to = c(2004, 4))

# Variables with no Census-era source (Unicon-only or May-only): always missing
# here (unicon_recnum, gradecom, gradehi, hoursumay, ind70/80, occ70/80).
recode_unavailable <- function(year) rep(NA_real_, length(year))

# --- household and family (generate_famid/proxy/hhtype/famtype.do) ---------
recode_famid <- function(prfamnum) as.numeric(prfamnum)
recode_hhtype <- function(hrhtype) as.numeric(hrhtype)
recode_famtype <- function(prfamtyp) as.numeric(prfamtyp)

# self or proxy response: 1 self, 2 proxy, 3 both
recode_proxy <- function(puslfprx) {
  dplyr::if_else(puslfprx >= 1 & puslfprx <= 3, as.numeric(puslfprx), NA_real_)
}

# --- hhwgt/famwgt (generate_hhwgt.do, generate_famwgt.do) -------------------
# The dictionaries already apply hwhhwgt's 4 implied decimals, except
# cpsbapr94 and cpsbjun95 (1994m4-1995m8), which read it unscaled.
recode_hhwgt <- function(hwhhwgt, year, month) {
  date <- ym(year, month)
  dplyr::if_else(date >= ym(1994, 4) & date <= ym(1995, 8), hwhhwgt / 10000, as.numeric(hwhhwgt))
}
recode_famwgt <- function(pwfmwgt) as.numeric(pwfmwgt)

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

# --- hoursvary1 (generate_hoursvary1.do): see hours_vary() in R/labor.R ---
recode_hoursvary1 <- function(pehrusl1) hours_vary(pehrusl1)

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

# --- ptwk: BLS top-code flag for weekly earnings, 2023m4+ (raw, used by tc_weekpay)
recode_ptwk <- function(ptwk) as.numeric(ptwk)

# --- tc_weekpay (generate_tc_weekpay.do) -------------------------------------
# The script tests `weekpay`, which doesn't exist yet at that point; Stata
# abbreviates it to weekpay_noadj (see DEVIATIONS.md). Fixed ceiling until
# 2023m3 ($1,923 through 1997; 2884.60 rather than 2884.61 to avoid float
# precision issues), then the BLS flag ptwk.
recode_tc_weekpay <- function(weekpay_noadj, ptwk, year, month) {
  ceiling <- dplyr::if_else(year <= 1997, 1923, 2884.60)
  tc <- dplyr::if_else(weekpay_noadj >= ceiling, 1, 0)
  dplyr::if_else(ym(year, month) >= ym(2023, 4) & !is.na(weekpay_noadj), as.numeric(ptwk), tc)
}

# --- allocation and top-code flags (generate_a_weekpay/a_earnhour/tc_earnhour.do)
# BLS allocation flags start 1995m9; `weekpay` is weekpay_noadj, as in tc_weekpay
allocated <- function(amount, flag, year, month) {
  has_amount <- ym(year, month) >= ym(1995, 9) & !is.na(amount) & amount > 0
  dplyr::case_when(has_amount & flag == 1 ~ 1, has_amount ~ 0, TRUE ~ NA_real_)
}
recode_a_weekpay <- function(weekpay_noadj, prwernal, year, month) allocated(weekpay_noadj, prwernal, year, month)
recode_a_earnhour <- function(earnhour, prhernal, year, month) allocated(earnhour, prhernal, year, month)
recode_tc_earnhour <- function(earnhour, pthr) dplyr::if_else(is.na(earnhour), NA_real_, as.numeric(pthr))

# --- overtime, tips and commissions (generate_otcrec/otcamt.do), hourly workers
recode_otcrec <- function(paidhre, peernuot) {
  dplyr::case_when(paidhre == 1 & peernuot == 2 ~ 0, paidhre == 1 & peernuot == 1 ~ 1, TRUE ~ NA_real_)
}
# weekly amount: peern, renamed ptern from 2024m6
recode_otcamt <- function(paidhre, otcrec, peern, ptern, year, month) {
  amount <- dplyr::if_else(ym(year, month) <= ym(2024, 5), as.numeric(peern), as.numeric(ptern))
  otcamt <- dplyr::if_else(paidhre == 1 & otcrec == 1, amount, NA_real_)
  nonnegative(otcamt)
}

# --- wageotc_noadj (generate_wageotc_noadj.do) ------------------------------
# Hourly workers' rate plus overtime/tips/commissions per hour; nonhourly
# workers get wage_noadj. The script checks peernhro but divides by hoursuorg,
# which equals peernhro whenever that check passes.
recode_wageotc_noadj <- function(paidhre, earnhour, otcrec, otcamt, peernhro, hoursuorg, wage_noadj) {
  with_otc <- paidhre == 1 & otcrec == 1 & !is.na(otcamt) & otcamt > 0 & peernhro > 0 & peernhro <= 99
  wageotc <- dplyr::case_when(
    paidhre == 1 ~ earnhour,
    paidhre == 0 ~ wage_noadj,
    TRUE ~ NA_real_
  )
  wageotc <- stata_replace(wageotc, with_otc, earnhour + otcamt / hoursuorg)
  dplyr::if_else(wageotc < 0, NA_real_, wageotc)
}
