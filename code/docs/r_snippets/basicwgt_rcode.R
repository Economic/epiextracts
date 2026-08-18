# --- basicwgt (generate_basicwgt.do), Census era Basic Monthly 1998+ -------
# Age floor uses the RAW (untopcoded) age variable, not the generated `age`.
recode_basicwgt <- function(cmpwgt, raw_age) {
  dplyr::if_else(raw_age < 16 | is.na(raw_age), NA_real_, cmpwgt)
}
