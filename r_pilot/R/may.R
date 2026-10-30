# May supplement recodes (1973-1981): the unicon_may source in
# variable_functions.csv. Most May variables follow the Unicon Basic rules
# (R/unicon.R; the scripts' `$monthlycps == 1 | $maycps == 1` branches);
# these are the May-only branches (`$maycps == 1`). Stata runs each May file
# as May of its year with $earnerinfo = 1 and $basicfile = 0.

# final weight: wgtfnl in hundredths
recode_finalwgt_may <- function(u_wgtfnl) {
  finalwgt <- u_wgtfnl / 100
  dplyr::if_else(finalwgt <= 0, NA_real_, finalwgt)
}

# metropolitan status: citystat (1-2 central city or balance of metro, 3
# nonmetro) through 1976, metstat after
recode_metstat_may <- function(u_citystat, u_metstat, year) {
  dplyr::case_when(
    year <= 1976 & u_citystat %in% c(1, 2) ~ 1,
    year <= 1976 & u_citystat == 3 ~ 0,
    year > 1976 & u_metstat == 1 ~ 1,
    year > 1976 & u_metstat == 2 ~ 0,
    TRUE ~ NA_real_
  )
}

# class of worker in 4 categories: 2 government, 3 self-employed
recode_selfemp_may <- function(u_class4) class_indicator_unicon(u_class4, u_class4 == 3)
recode_pubsec_may <- function(u_class4) class_indicator_unicon(u_class4, u_class4 == 2)

# union items are coded 0 = yes, 1 = no in the May files; coverage from 1977
recode_unmem_may <- function(u_unmem) dplyr::case_when(u_unmem == 1 ~ 0, u_unmem == 0 ~ 1, TRUE ~ NA_real_)
recode_uncov_may <- function(u_uncov, year) {
  dplyr::if_else(year >= 1977, dplyr::case_when(u_uncov == 1 ~ 0, u_uncov == 0 ~ 1, TRUE ~ NA_real_), NA_real_)
}
# missing through 1976
recode_union_may <- function(unmem, uncov, year) {
  dplyr::if_else(year <= 1976, NA_real_, recode_union(unmem, uncov))
}

# paid by the hour: hourpd (0 = yes, 1 = no) through 1978, _ernpdh after
recode_paidhre_may <- function(u_hourpd, u__ernpdh, year) {
  dplyr::case_when(
    year <= 1978 & u_hourpd == 0 ~ 1,
    year <= 1978 & u_hourpd == 1 ~ 0,
    year > 1978 & u__ernpdh == 2 ~ 0,
    year > 1978 & u__ernpdh == 1 ~ 1,
    TRUE ~ NA_real_
  )
}

# usual weekly hours (May supplement question)
recode_hoursumay <- function(u_wkhrswk) nonnegative(u_wkhrswk)

# usual hours at the earnings job, 1979+
recode_hoursuorg_may <- function(u_ernush, year) nonnegative(dplyr::if_else(year >= 1979, as.numeric(u_ernush), NA_real_))

# weekly earnings: wkusern through 1978, ernwkc after; the 1980 May earnings
# are set missing (a known problem with that file)
recode_weekpay_noadj_may <- function(u_wkusern, u_ernwkc, year) {
  weekpay <- dplyr::case_when(year <= 1978 ~ as.numeric(u_wkusern), year == 1980 ~ NA_real_, TRUE ~ as.numeric(u_ernwkc))
  nonnegative(weekpay)
}

# hourly rate in cents: hourern through 1978, ernhr after
recode_earnhour_may <- function(u_hourern, u_ernhr, year) {
  nonnegative(dplyr::if_else(year <= 1978, u_hourern / 100, u_ernhr / 100))
}

# hours behind a nonhourly worker's weekly pay: the May question through
# 1978, usual hours at the earnings job after
may_wage_hours <- function(hoursumay, hoursuorg, year) dplyr::if_else(year <= 1978, hoursumay, hoursuorg)

# hourly wage: the rate for hourly workers, weekly earnings over hours for
# others (Stata's x/0 is missing); missing in 1980
recode_wage_noadj_may <- function(paidhre, earnhour, weekpay_noadj, hoursumay, hoursuorg, year) {
  hours <- may_wage_hours(hoursumay, hoursuorg, year)
  wage2 <- dplyr::if_else(paidhre == 0 & !is.na(hours) & hours != 0, weekpay_noadj / hours, NA_real_)
  wage2 <- dplyr::if_else(wage2 < 0, NA_real_, wage2)
  wage <- dplyr::case_when(paidhre == 1 ~ earnhour, paidhre == 0 ~ wage2, TRUE ~ NA_real_)
  dplyr::if_else(year == 1980, NA_real_, wage)
}

# --- wage stage (adjust_wages.do), May ---------------------------------------

#' weekpay for May: the $999 top-code Pareto adjustment by sex, weighted by
#' basicwgt (May has no earnings weight for every year); 1980 missing.
add_weekpay_may <- function(data) {
  data$weekpay <- NA_real_
  if (nrow(data) == 0 || unique(data$year) == 1980) return(data)
  for (sex in c(0, 1)) {
    idx <- which(data$female == sex & !is.na(data$weekpay_noadj) & !is.na(data$age) & data$age >= 16 & !is.na(data$basicwgt))
    if (length(idx) == 0) next
    data$weekpay[idx] <- topcode_impute_pareto(data$weekpay_noadj[idx], data$basicwgt[idx], threshold = 80, topcodeval = 999)$value
  }
  data
}

#' wage for May: hourly workers' wage_noadj; others' adjusted weekpay over
#' hours (May question through 1978, earnings-job hours after), trimmed by
#' the CPI bounds.
add_wage_may <- function(data, wage_bounds) {
  data |>
    dplyr::left_join(wage_bounds, by = "year") |>
    dplyr::mutate(
      hours = may_wage_hours(hoursumay, hoursuorg, year),
      wage2_adjusted = dplyr::if_else(paidhre == 0 & !is.na(hours) & hours != 0, weekpay / hours, NA_real_),
      wage2_adjusted = dplyr::if_else(wage2_adjusted < 0, NA_real_, wage2_adjusted),
      wage = dplyr::case_when(paidhre == 1 ~ wage_noadj, paidhre == 0 ~ wage2_adjusted, TRUE ~ NA_real_),
      wage = dplyr::if_else(wage < wage_lower | wage > wage_upper, NA_real_, wage, missing = wage)
    ) |>
    dplyr::select(-hours, -wage2_adjusted, -wage_lower, -wage_upper)
}
