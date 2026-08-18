# --- married (generate_married.do), 1994+ ----------------------------------
recode_married <- function(prmarsta) {
  dplyr::case_when(
    prmarsta >= 4 & prmarsta <= 7 ~ 0,
    prmarsta >= 1 & prmarsta <= 3 ~ 1,
    TRUE                          ~ NA_real_
  )
}
