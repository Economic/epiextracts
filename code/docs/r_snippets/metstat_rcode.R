# --- metstat (generate_metstat.do) ----------------------------------------
# gemetsta (...-2004m4) -> gtmetsta (2004m5+), both recoded 1->1 (metro),
# 2->0 (nonmetro). Stata splits 1994m1-1995m5 and 1995m9-2004m4, but both use
# the same raw column, so one 2004m5 boundary suffices. The 1995m6-1995m8
# gap (no metro data) is not handled yet: needed when 1994-1999 is added.
recode_metstat <- function(year, month, gemetsta, gtmetsta) {
  src <- dplyr::if_else(year < 2004 | (year == 2004 & month <= 4), as.numeric(gemetsta), as.numeric(gtmetsta))
  dplyr::case_when(
    src == 1 ~ 1,
    src == 2 ~ 0,
    TRUE     ~ NA_real_
  )
}
