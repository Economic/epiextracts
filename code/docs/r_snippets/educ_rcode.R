# --- educ (generate_educ.do), 1994+ ----------------------------------------
recode_educ <- function(peeduca) {
  dplyr::case_when(
    peeduca >= 31 & peeduca <= 38 ~ 1,
    peeduca == 39                 ~ 2,
    peeduca >= 40 & peeduca <= 42 ~ 3,
    peeduca == 43                 ~ 4,
    peeduca >= 44 & peeduca <= 46 ~ 5,
    TRUE                          ~ NA_real_
  )
}
