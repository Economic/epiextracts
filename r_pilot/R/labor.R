# Labor force, class of worker, unemployment durations and hours recodes
# (Census era, Basic/ORG). Each function's arguments are the columns it
# reads; see R/registry.R.

# --- labor force detail (generate_dlfstat/emphrs/whyabsent/whyunemp.do) ----
# raw codes kept as-is; only "not in universe" (-1) is set missing
drop_niu <- function(x) {
  x <- as.numeric(x)
  dplyr::if_else(x == -1, NA_real_, x)
}
recode_dlfstat <- function(pemlr) drop_niu(pemlr)
recode_emphrs <- function(premphrs) drop_niu(premphrs)
recode_whyabsent <- function(peabsrsn) drop_niu(peabsrsn)
recode_whyunemp <- function(pruntype) drop_niu(pruntype)

# --- unemp/nilf (generate_unemp.do, generate_nilf.do) -----------------------
recode_unemp <- function(lfstat) dplyr::if_else(lfstat == 2, 1, 0)
recode_nilf <- function(lfstat) dplyr::if_else(lfstat == 3, 1, 0)

# --- job changes and multiple jobs (generate_samejob/multjobs/numjobs.do) --
recode_samejob <- function(puiodp1) yes_no(puiodp1)
recode_multjobs <- function(pemjot) yes_no(pemjot)

# employed people have at least one job; pemjnum counts jobs for multiple job holders
recode_numjobs <- function(emp, pemjnum) {
  numjobs <- dplyr::if_else(emp == 1, 1, NA_real_, missing = NA_real_)
  stata_replace(numjobs, pemjnum %in% 2:4, pemjnum)
}

# --- class of worker (generate_cow1/cow2/selfemp/selfinc/pub*.do) -----------
# indicators are 0 for anyone with a class of worker, 1 for the matching class
class_indicator <- function(peio1cow, class) {
  has_class <- !is.na(peio1cow) & peio1cow >= 1
  dplyr::case_when(peio1cow == class ~ 1, has_class ~ 0, TRUE ~ NA_real_)
}
recode_pubfed <- function(peio1cow) class_indicator(peio1cow, 1)
recode_pubst <- function(peio1cow) class_indicator(peio1cow, 2)
recode_publoc <- function(peio1cow) class_indicator(peio1cow, 3)
recode_selfinc <- function(peio1cow) class_indicator(peio1cow, 6)
recode_selfemp <- function(peio1cow) class_indicator(peio1cow, 7)

recode_cow1 <- function(peio1cow) dplyr::if_else(peio1cow <= 0, NA_real_, as.numeric(peio1cow))
recode_cow2 <- function(peio2cow) dplyr::if_else(peio2cow <= 0, NA_real_, as.numeric(peio2cow))

# --- unemployment durations (generate_unempdur/lookdur.do) ------------------
recode_unempdur <- function(prunedur) nonnegative(prunedur)
recode_lookdur <- function(pelkdur) nonnegative(pelkdur)

# --- discwork (generate_discwork.do): everyone 0 unless discouraged ----------
recode_discwork <- function(prdisc) dplyr::if_else(prdisc %in% c(1, 2), 1, 0)

# --- part-time and work status (generate_ptecon.do, generate_ftptstat.do) --
# ptecon covers work statuses 2-10; 3 and 6 are part-time for economic reasons
recode_ptecon <- function(prwkstat) {
  dplyr::case_when(
    prwkstat %in% c(3, 6) ~ 1,
    prwkstat >= 2 & prwkstat <= 10 ~ 0,
    TRUE ~ NA_real_
  )
}
recode_ftptstat <- function(prwkstat) dplyr::if_else(prwkstat <= 0, NA_real_, as.numeric(prwkstat))

# --- hours (generate_hoursu2/hoursut/hourslw1/hourslw2/hourslwt.do) ---------
recode_hoursu2 <- function(pehrusl2) nonnegative(pehrusl2)
recode_hoursut <- function(pehruslt) nonnegative(pehruslt)
recode_hourslw1 <- function(pehract1) nonnegative(pehract1)
recode_hourslw2 <- function(pehract2) nonnegative(pehract2)
recode_hourslwt <- function(pehractt) nonnegative(pehractt)

# --- hours vary (generate_hoursvary/hoursvary2/hoursvaryt.do) ---------------
# -4 is Census's "hours vary" code. The unguarded `>= 0` in Stata is true for
# missing, so missing raw hours count as "do not vary".
hours_vary <- function(hours) {
  dplyr::case_when(hours == -4 ~ 1, as_stata(hours) >= 0 ~ 0, TRUE ~ NA_real_)
}
recode_hoursvary <- function(pehrusl1) hours_vary(pehrusl1)
recode_hoursvary2 <- function(pehrusl2) hours_vary(pehrusl2)
recode_hoursvaryt <- function(pehruslt) hours_vary(pehruslt)

# --- telework (generate_telework.do, generate_hourslwtw.do) -----------------
# 2022m10-2024m5 from the telework supplement (ptcovr1/ptcovr2, merged in
# read_raw_year()); the basic file carries pttlwk/pttlwkhr from 2024m6
recode_telework <- function(year, month, ptcovr1, pttlwk) {
  date <- ym(year, month)
  telework <- dplyr::case_when(
    date >= ym(2022, 10) & date <= ym(2024, 5) ~ as.numeric(ptcovr1),
    date >= ym(2024, 6) ~ as.numeric(pttlwk),
    TRUE ~ NA_real_
  )
  telework <- dplyr::if_else(telework == 2, 0, telework)
  nonnegative(telework)
}
recode_hourslwtw <- function(year, month, ptcovr2, pttlwkhr) {
  date <- ym(year, month)
  hours <- dplyr::case_when(
    date >= ym(2022, 10) & date <= ym(2024, 5) ~ as.numeric(ptcovr2),
    date >= ym(2024, 6) ~ as.numeric(pttlwkhr),
    TRUE ~ NA_real_
  )
  nonnegative(hours)
}
