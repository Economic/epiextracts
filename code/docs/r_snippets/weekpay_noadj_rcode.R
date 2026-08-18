# --- weekpay_noadj (generate_weekpay_noadj.do): raw weekly earnings ------
# prernwa (...-2021m2) / pternwa (2021m3+), same rename boundary as earnhour.
recode_weekpay_noadj <- function(year, month, prernwa, pternwa) {
  weekpay_noadj <- dplyr::if_else(
    year < 2021 | (year == 2021 & month <= 2),
    as.numeric(prernwa),
    as.numeric(pternwa)
  )
  dplyr::if_else(weekpay_noadj < 0, NA_real_, weekpay_noadj)
}
