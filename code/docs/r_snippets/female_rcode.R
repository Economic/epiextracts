# --- female (generate_female.do), Census era Basic Monthly -----------------
recode_female <- function(pesex) {
  dplyr::case_when(
    pesex == 1 ~ 0,
    pesex == 2 ~ 1,
    TRUE       ~ NA_real_
  )
}
