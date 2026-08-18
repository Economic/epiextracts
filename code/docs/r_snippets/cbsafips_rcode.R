# --- cbsafips (generate_cbsafips.do), Basic Monthly only ------------------
# Unpopulated before 2004m5 (gtcbsa doesn't exist as a raw column until then).
recode_cbsafips <- function(year, month, gtcbsa) {
  dplyr::if_else(year > 2004 | (year == 2004 & month >= 5), as.numeric(gtcbsa), NA_real_)
}
