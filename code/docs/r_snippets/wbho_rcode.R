# --- wbho (generate_wbho.do), 1994+ ----------------------------------------
# Race source column/coding changes at 2003 and again at 2012m5; ptdtrace was
# renamed prdtrace for a ~15-month window (May 2004-Jul 2005), same pattern as
# peage/prtage -- coalesce() handles it. Hispanic ethnicity always overrides.
recode_wbho <- function(year, month, perace, ptdtrace, prdtrace, hispanic) {
  ptdtrace_eff <- dplyr::coalesce(as.numeric(ptdtrace), as.numeric(prdtrace))
  is_pre2003    <- year <= 2002
  is_2003_2012a <- year >= 2003 & (year < 2012 | (year == 2012 & month <= 4))
  is_2012b_on   <- year > 2012 | (year == 2012 & month >= 5)

  race <- dplyr::case_when(
    is_pre2003 & perace == 1 ~ 1,
    is_pre2003 & perace == 2 ~ 2,
    is_pre2003 & perace >= 3 & perace <= 4 ~ 4,

    is_2003_2012a & ptdtrace_eff == 1 ~ 1,
    is_2003_2012a & (ptdtrace_eff == 2 | ptdtrace_eff %in% c(6, 10, 11, 12, 15, 16, 19)) ~ 2,
    is_2003_2012a & ((ptdtrace_eff >= 3 & ptdtrace_eff <= 5) |
                       ptdtrace_eff %in% c(7, 8, 9, 13, 14, 17, 18, 20, 21)) ~ 4,

    is_2012b_on & ptdtrace_eff == 1 ~ 1,
    is_2012b_on & (ptdtrace_eff == 2 | ptdtrace_eff %in% c(6, 10, 11, 12, 16, 17, 18, 22, 23)) ~ 2,
    is_2012b_on & ((ptdtrace_eff >= 3 & ptdtrace_eff <= 5) |
                     ptdtrace_eff %in% c(7, 8, 9, 13, 14, 15, 19, 20, 21, 24, 25, 26)) ~ 4,

    TRUE ~ NA_real_
  )
  dplyr::if_else(hispanic == 1, 3, race, missing = race)
}
