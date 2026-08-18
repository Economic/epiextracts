# --- emp (generate_emp.do) --------------------------------------------------
recode_emp <- function(lfstat) {
  dplyr::case_when(
    !is.na(lfstat) & lfstat == 1 ~ 1,
    !is.na(lfstat)               ~ 0,
    TRUE                         ~ NA_real_
  )
}
