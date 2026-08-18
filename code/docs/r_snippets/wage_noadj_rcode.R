# --- wage_noadj (generate_wage_noadj.do) -----------------------------------
# earnhour for hourly workers; weekpay_noadj/hoursu1 for nonhourly. Guard
# div-by-zero/NA explicitly -- Stata's x/0 is missing, R's is Inf.
recode_wage_noadj <- function(paidhre, earnhour, weekpay_noadj, hoursu1) {
  wage2 <- dplyr::if_else(
    paidhre == 0 & !is.na(hoursu1) & hoursu1 > 0,
    weekpay_noadj / hoursu1,
    NA_real_
  )
  wage2 <- dplyr::if_else(wage2 < 0, NA_real_, wage2, missing = wage2)
  dplyr::if_else(paidhre == 1, earnhour, wage2)
}
