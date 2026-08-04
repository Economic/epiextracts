# Port of code/ado/topcode_impute.ado, method(Pareto). Validated to 0
# mismatches against real weekpay reference values (both sexes, multiple years).

# Stata's weighted-percentile convention (order-statistic based on cumulative
# weight; the exact interpolation matters because it determines which bins
# enter the Pareto-tail regression below).
stata_pctile <- function(x, w, p) {
  ord <- order(x)
  x <- x[ord]; w <- w[ord]
  cw <- cumsum(w)
  n <- sum(w)
  Np <- n * p / 100
  tol <- 1e-7 * max(1, abs(Np))
  if (abs(Np - round(Np)) < tol) {
    k <- round(Np)
    i1 <- which(cw >= k)[1]
    i2 <- which(cw >= k + 1)[1]
    if (is.na(i2)) i2 <- i1
    (x[i1] + x[i2]) / 2
  } else {
    x[which(cw >= Np)[1]]
  }
}

#' Pareto tail-imputation for top-coded values.
#'
#' x must have no NA (caller pre-filters). Steps: find the weighted
#' `threshold`-th percentile; cap x at topcodeval; bin into $50 buckets and
#' build a weighted survival count (bin populations must be a literal
#' weighted sum, matching Stata's `collapse (sum) n [pweight=w]`); fit the
#' Pareto shape parameter alpha via a log-log regression on the tail above
#' the threshold bin; replace capped values with the implied conditional mean
#' above the top-code, topcodeval * alpha / (alpha - 1).
topcode_impute_pareto <- function(x, w, threshold = 80, topcodeval) {
  thresholdval <- stata_pctile(x, w, threshold)
  stopifnot(thresholdval > 0)

  xcap <- ifelse(x >= topcodeval, topcodeval, x)
  bin <- stata_round(xcap / 50) * 50

  agg <- stats::aggregate(w, by = list(bin = bin), FUN = sum)
  names(agg) <- c("bin", "n")
  agg <- agg[order(-agg$bin), ]
  agg$running <- cumsum(agg$n)

  cutoff <- stata_round(thresholdval * 50) / 50
  agg2 <- agg[agg$bin >= cutoff, ]

  fit <- stats::lm(log(running) ~ log(bin), data = agg2)
  alpha <- -stats::coef(fit)[["log(bin)"]]
  newmeanabove <- topcodeval * alpha / (alpha - 1)

  value <- xcap
  value[xcap >= topcodeval] <- newmeanabove

  list(value = value, thresholdval = thresholdval, alpha = alpha, newmeanabove = newmeanabove)
}

#' Pareto-imputed conditional mean above `topcodeval`, fit separately by sex
#' on `d` (weighted by orgwgt, restricted to age >= 16, non-missing
#' weekpay_noadj). Returns list(male = <scalar>, female = <scalar>) -- the
#' single imputed mean that replaces every topcoded value for that sex.
pareto_constants_by_sex <- function(d, topcodeval, threshold = 80) {
  compute_one <- function(sex) {
    s <- d[d$female == sex & !is.na(d$weekpay_noadj) & !is.na(d$age) & d$age >= 16, ]
    topcode_impute_pareto(s$weekpay_noadj, s$orgwgt, threshold = threshold, topcodeval = topcodeval)$newmeanabove
  }
  list(male = compute_one(0), female = compute_one(1))
}

#' tc_weekpay (topcode flag, internal-only -- needed only to know which rows
#' below should be corrected). weekpay >= threshold and weekpay_noadj >=
#' threshold are mathematically identical whenever threshold <= topcodeval,
#' since the Pareto-imputed mean is always >= topcodeval. For 2023m4+ there's
#' no fixed numeric ceiling anymore, so use the literal BLS-supplied flag ptwk.
compute_tc_weekpay <- function(weekpay_noadj, ptwk, year, month) {
  dplyr::if_else(
    (year == 2023 & month >= 4) | year >= 2024,
    as.numeric(ptwk),
    dplyr::if_else(!is.na(weekpay_noadj) & weekpay_noadj >= 2884.60, 1, 0, missing = 0)
  )
}

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
