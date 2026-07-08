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

#' Recode one year's raw table into the four pilot variables.
#'
#' Applies the sample_cpsbasic.do universe filter (drop rows with negative raw
#' age entirely) before recoding -- this is distinct from recode_age()'s rule
#' of setting `age` to missing, and is required for row-count parity against
#' the published Stata extracts, not just column-level correctness.
recode_year <- function(raw_year, reweight_years) {
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
      basicwgt = recode_basicwgt(cmpwgt, raw_age)
    ) |>
    dplyr::select(hrhhid, hhid, personid, year, month, age, female, emp, basicwgt)
}
