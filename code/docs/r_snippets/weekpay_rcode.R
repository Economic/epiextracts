#' weekpay (generate_weekpay.do + code/tc_fix.do), era-aware in one pass --
#' no separate "fix" step, matching the same date-branch style Stata's
#' generate_weekpay.do already uses for older regime boundaries (1973-88 /
#' 1989-97 / 1998-2024 / 2025+), just extended to cover the 2023m4-2024m3
#' dynamic top-code phase-in as further branches instead of a bolt-on patch.
#'
#' - pre-2023: single fixed topcodeval=2884.60 regime, Pareto-fit and applied
#'   over the whole year, by sex.
#' - 2023 Jan-Mar: same fixed-ceiling regime, but Census's dynamic rollout is
#'   already underway for minsamp==4 respondents starting month 4 -- so the
#'   reference Pareto constants are fit on a subsample of this same year's
#'   data that excludes those already-rolled-out rows.
#' - 2023 Apr-Dec / 2024 Jan-Mar: Census's dynamic top-code, phased in by
#'   rotation group -- minsamp==4 (incoming) gets that month's dynamic code;
#'   minsamp==8 (still outgoing) is corrected via a weighted mean of
#'   minsamp==4 respondents at/above the old fixed ceiling that month.
#' - 2024 Apr-Dec+: dynamic top-code fully standardized -- weekpay used as
#'   reported (2024 Apr-Dec via monthly max fallback for edge topcoded rows;
#'   2025+ passthrough, matching generate_weekpay.do).
add_weekpay <- function(org_year) {
  year <- unique(org_year$year)
  d <- org_year

  if (year < 2023) {
    d$weekpay <- NA_real_
    for (sex in c(0, 1)) {
      idx <- d$female == sex & !is.na(d$weekpay_noadj) & !is.na(d$age) & d$age >= 16
      res <- topcode_impute_pareto(d$weekpay_noadj[idx], d$orgwgt[idx],
                                    threshold = 80, topcodeval = 2884.60)
      d$weekpay[idx] <- res$value
    }
    return(d)
  }

  if (year >= 2025) {
    d$weekpay <- d$weekpay_noadj
    return(d)
  }

  d$tc_weekpay <- compute_tc_weekpay(d$weekpay_noadj, d$ptwk, d$year, d$month)
  d$weekpay <- d$weekpay_noadj

  wtd_mean <- function(x, w) sum(x * w) / sum(w)

  if (year == 2023) {
    ref <- d[!(d$minsamp == 4 & d$month >= 4), ]
    constants <- pareto_constants_by_sex(ref, topcodeval = 2884.60)

    idx13 <- d$month <= 3 & d$tc_weekpay == 1
    d$weekpay[idx13 & d$female == 0] <- constants$male
    d$weekpay[idx13 & d$female == 1] <- constants$female

    for (m in 4:12) {
      idx4 <- d$tc_weekpay == 1 & d$minsamp == 4 & d$month == m
      d$weekpay[idx4] <- max(d$weekpay_noadj[d$month == m], na.rm = TRUE)

      idx8 <- d$tc_weekpay == 1 & d$minsamp == 8 & d$month == m
      sub <- d[d$month == m & !is.na(d$weekpay_noadj) & d$weekpay_noadj >= 2884.6 & d$minsamp == 4, ]
      d$weekpay[idx8] <- wtd_mean(sub$weekpay_noadj, sub$orgwgt)
    }
    return(d)
  }

  # year == 2024
  for (m in 1:3) {
    idx4 <- d$tc_weekpay == 1 & d$minsamp == 4 & d$month == m
    d$weekpay[idx4] <- max(d$weekpay_noadj[d$month == m], na.rm = TRUE)

    idx8 <- d$tc_weekpay == 1 & d$minsamp == 8 & d$month == m
    sub <- d[d$month == m & !is.na(d$weekpay_noadj) & d$weekpay_noadj >= 2884.6 & d$minsamp == 4, ]
    d$weekpay[idx8] <- wtd_mean(sub$weekpay_noadj, sub$orgwgt)
  }
  for (m in 4:12) {
    idx <- d$tc_weekpay == 1 & d$month == m
    d$weekpay[idx] <- max(d$weekpay_noadj[d$month == m], na.rm = TRUE)
  }
  d
}
