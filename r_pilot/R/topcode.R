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

#' weekpay (generate_weekpay.do): Pareto top-code imputation of weekpay_noadj,
#' fit separately by sex, weighted by orgwgt. 2000-2024 is entirely within the
#' single 1998m1-2024m12 topcodeval=2884.60 regime, so no era-branching needed.
add_weekpay <- function(org_year) {
  org_year$weekpay <- NA_real_
  for (sex in c(0, 1)) {
    idx <- org_year$female == sex & !is.na(org_year$weekpay_noadj) &
      !is.na(org_year$age) & org_year$age >= 16
    res <- topcode_impute_pareto(org_year$weekpay_noadj[idx], org_year$orgwgt[idx],
                                  threshold = 80, topcodeval = 2884.60)
    org_year$weekpay[idx] <- res$value
  }
  org_year
}
