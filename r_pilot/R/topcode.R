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
#' Rows the top-code adjustment uses: Stata's `topcode_impute weekpay_noadj
#' if weekpay_noadj ~= . & female == <sex> & age >= 16 [pw=orgwgt]`. Rows
#' without an earnings weight drop out (in the Basic table, everyone outside
#' the outgoing rotations), so their weekpay stays missing.
pareto_rows <- function(d, sex) {
  which(d$female == sex & !is.na(d$weekpay_noadj) & !is.na(d$age) & d$age >= 16 & !is.na(d$orgwgt))
}

#' Pareto-imputed conditional mean above `topcodeval`, fit separately by sex
#' on `d`. Returns list(male = <scalar>, female = <scalar>) -- the single
#' imputed mean that replaces every topcoded value for that sex.
pareto_constants_by_sex <- function(d, topcodeval, threshold = 80) {
  compute_one <- function(sex) {
    s <- d[pareto_rows(d, sex), ]
    topcode_impute_pareto(s$weekpay_noadj, s$orgwgt, threshold = threshold, topcodeval = topcodeval)$newmeanabove
  }
  list(male = compute_one(0), female = compute_one(1))
}

#' Dynamic top-code months (code/tc_fix.do): top-coded weekpay becomes the
#' month's highest reported weekpay_noadj -- for minsamp 4 only, or for every
#' rotation once the phase-in is complete -- and, during the phase-in,
#' minsamp 8 gets the weighted mean of minsamp 4 earnings at or above the old
#' $2,884.60 ceiling. Maxima and means come from the table being adjusted
#' (Basic or ORG), as tc_fix.do runs on each file.
dynamic_topcode_month <- function(d, m, phase_in) {
  in_month <- !is.na(d$month) & d$month == m
  topcoded <- in_month & d$tc_weekpay %in% 1
  month_max <- max(d$weekpay_noadj[in_month], na.rm = TRUE)
  if (!phase_in) {
    d$weekpay[topcoded] <- month_max
    return(d)
  }
  d$weekpay[topcoded & d$minsamp %in% 4] <- month_max
  above <- which(in_month & d$minsamp %in% 4 & !is.na(d$weekpay_noadj) & d$weekpay_noadj >= 2884.6 & !is.na(d$orgwgt))
  d$weekpay[topcoded & d$minsamp %in% 8] <- sum(d$weekpay_noadj[above] * d$orgwgt[above]) / sum(d$orgwgt[above])
  d
}

#' weekpay (generate_weekpay.do + code/tc_fix.do), era-aware in one pass --
#' no separate "fix" step. Runs on the Basic and on the ORG table.
#'
#' - pre-2023: fixed ceiling ($999 through 1988, $1,923 through 1997,
#'   $2,884.60 from 1998),
#'   Pareto-fit and applied over the whole year, by sex.
#' - 2023 Jan-Mar: same fixed-ceiling regime, with Pareto constants fit on
#'   the year's ORG rows minus the minsamp 4 rows already under the dynamic
#'   top-code from April (tc_fix.do fits them on the ORG file for both samples).
#' - 2023 Apr-Dec / 2024 Jan-Mar: Census's dynamic top-code, phased in by
#'   rotation group (dynamic_topcode_month()).
#' - 2024 Apr-Dec: dynamic top-code fully standardized.
#' - 2025+: weekpay as reported (generate_weekpay.do).
add_weekpay <- function(data) {
  # a partial year's trailing window spans two years: top-code each year on its own
  if (length(unique(data$year)) > 1) {
    return(dplyr::bind_rows(purrr::map(split(data, data$year), add_weekpay)))
  }
  year <- unique(data$year)
  d <- data

  if (year < 2023) {
    # fixed weekly ceiling: $999 through 1988, $1,923 through 1997, $2,884.61
    # from 1998 (2884.60 avoids float precision issues, as in generate_weekpay.do)
    topcodeval <- if (year <= 1988) 999 else if (year <= 1997) 1923 else 2884.60
    d$weekpay <- NA_real_
    for (sex in c(0, 1)) {
      idx <- pareto_rows(d, sex)
      # files without earnings data (Unicon basic files before 1982) have none
      if (length(idx) == 0) next
      res <- topcode_impute_pareto(d$weekpay_noadj[idx], d$orgwgt[idx],
                                    threshold = 80, topcodeval = topcodeval)
      d$weekpay[idx] <- res$value
    }
    return(d)
  }

  d$weekpay <- d$weekpay_noadj
  if (year >= 2025) return(d)

  if (year == 2023) {
    org_rows <- d$minsamp %in% c(4, 8) & !is.na(d$orgwgt) & d$orgwgt > 0 & !is.na(d$age) & d$age >= 16
    ref <- d[org_rows & !(d$minsamp %in% 4 & d$month >= 4), ]
    constants <- pareto_constants_by_sex(ref, topcodeval = 2884.60)

    early <- d$month <= 3 & d$tc_weekpay %in% 1
    d$weekpay[early & d$female %in% 0] <- constants$male
    d$weekpay[early & d$female %in% 1] <- constants$female
    for (m in 4:12) d <- dynamic_topcode_month(d, m, phase_in = TRUE)
    return(d)
  }

  # year == 2024
  for (m in 1:3) d <- dynamic_topcode_month(d, m, phase_in = TRUE)
  for (m in 4:12) d <- dynamic_topcode_month(d, m, phase_in = FALSE)
  d
}
