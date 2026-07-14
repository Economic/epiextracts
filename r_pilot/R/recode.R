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

# --- basicwgt (generate_basicwgt.do), Census era Basic Monthly 1998+ -------
# Age floor uses the RAW (untopcoded) age variable, not the generated `age`.
recode_basicwgt <- function(cmpwgt, raw_age) {
  dplyr::if_else(raw_age < 16 | is.na(raw_age), NA_real_, cmpwgt)
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

#' Recode one year's raw table into the pilot variables.
#'
#' Applies the sample_cpsbasic.do universe filter (drop rows with negative raw
#' age entirely) before recoding -- this is distinct from recode_age()'s rule
#' of setting `age` to missing, and is required for row-count parity against
#' the published Stata extracts, not just column-level correctness.
#'
#' minsamp/orgwgt/paidhre..wage_noadj are computed for every basic-level row
#' (not just the ORG subset), mirroring how basicwgt is computed unconditionally
#' -- ORG membership is an orthogonal downstream row filter, not a separate
#' source of these columns.
recode_year <- function(raw_year, reweight_years, state_geocodes) {
  raw_year |>
    dplyr::mutate(raw_age = recode_raw_age(peage, prtage)) |>
    dplyr::filter(raw_age >= 0) |>
    dplyr::mutate(
      hhid     = as.numeric(qstnum),    # generate_hhid.do: 1998+ = qstnum
      personid = as.numeric(occurnum),  # generate_personid.do: 1998+ = occurnum
      year     = hryear4,
      month    = hrmonth,
      age      = recode_age(raw_age),
      female   = recode_female(pesex),
      lfstat   = recode_lfstat(pemlr),
      emp      = recode_emp(lfstat),
      cmpwgt   = recode_cmpwgt(pwcmpwgt, nwcmpwgt, year, reweight_years),
      basicwgt = recode_basicwgt(cmpwgt, raw_age),
      minsamp  = recode_minsamp(hrmis),
      orgwgt   = recode_orgwgt(pworwgt, nworwgt, year, reweight_years),
      paidhre       = recode_paidhre(peernhry),
      hoursu1       = recode_hoursu1(pehrusl1),
      hoursvary1    = recode_hoursvary1(pehrusl1),
      hoursuint     = recode_hoursuint(prhrusl),
      hoursuorg     = recode_hoursuorg(peernhro, hoursu1, minsamp),
      earnhour      = recode_earnhour(year, month, prernhly, pternhly),
      weekpay_noadj = recode_weekpay_noadj(year, month, prernwa, pternwa),
      wage_noadj    = recode_wage_noadj(paidhre, earnhour, weekpay_noadj, hoursu1),
      ptwk          = as.numeric(ptwk),  # BLS-supplied topcode flag, tc_fix.do 2023m4+ only
      # 8 demographic/employment/industry covariates -- computed at the basic
      # level (not just ORG) since Stata generates them identically regardless
      # of sample; union/unmem/uncov end up mostly NA outside the ORG-eligible
      # rotation groups, matching actual Stata behavior, not a gap to fix.
      educ      = recode_educ(peeduca),
      hispanic  = recode_hispanic(year, prorigin, prdthsp),
      wbho      = recode_wbho(year, month, perace, ptdtrace, prdtrace, hispanic),
      citistat  = recode_citistat(prcitshp),
      married   = recode_married(prmarsta),
      statefips = recode_statefips(gestfips),
      union     = recode_union(peernlab, peerncov),
      pubsec    = recode_pubsec(peio1cow),
      indcode   = recode_indcode(peio1icd),
      mind16    = recode_mind16(indcode, year),
      # geography: countyfips/cbsafips/cbsasize/metstat are direct raw-column
      # passthroughs (no crosswalk); statecensus/division/region come from a
      # left-join below since they live in a separate lookup table, not a raw column
      countyfips = recode_countyfips(year, month, geco, gtco),
      cbsafips   = recode_cbsafips(year, month, gtcbsa),
      cbsasize   = recode_cbsasize(year, month, gtcbsasz),
      metstat    = recode_metstat(year, month, gemetsta, gtmetsta)
    ) |>
    dplyr::left_join(state_geocodes, by = "statefips") |>
    dplyr::select(
      hrhhid, hhid, personid, year, month, age, female, emp, basicwgt,
      minsamp, orgwgt, paidhre, hoursu1, hoursvary1, hoursuint, hoursuorg,
      earnhour, weekpay_noadj, wage_noadj, ptwk,
      educ, wbho, citistat, married, statefips, union, pubsec, mind16,
      statecensus, division, region, countyfips, cbsafips, cbsasize, metstat
    )
}
