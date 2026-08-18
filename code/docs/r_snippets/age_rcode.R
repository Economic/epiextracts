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
