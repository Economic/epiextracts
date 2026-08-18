# --- cbsasize (generate_cbsasize.do), Basic Monthly only ------------------
# Same 2004m5 boundary as cbsafips.
recode_cbsasize <- function(year, month, gtcbsasz) {
  dplyr::if_else(year > 2004 | (year == 2004 & month >= 5), as.numeric(gtcbsasz), NA_real_)
}
