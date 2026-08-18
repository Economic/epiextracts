# --- metstat (generate_metstat.do) ----------------------------------------
# gemetsta (...-2004m4) -> gtmetsta (2004m5+), both recoded 1->1 (metro),
# 2->0 (nonmetro). The 1994m1-1995m5/1995m9-2004m4 Stata sub-split collapses
# to a single 2004m5 boundary here since both sub-eras share the same raw
# column; the 1995m6-1995m8 Census-side suppression gap predates our 2000-2024
# scope entirely.
recode_metstat <- function(year, month, gemetsta, gtmetsta) {
  src <- dplyr::if_else(year < 2004 | (year == 2004 & month <= 4), as.numeric(gemetsta), as.numeric(gtmetsta))
  dplyr::case_when(
    src == 1 ~ 1,
    src == 2 ~ 0,
    TRUE     ~ NA_real_
  )
}
