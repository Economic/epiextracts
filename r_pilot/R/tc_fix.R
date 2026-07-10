# Retroactive 2023-2024 top-code correction (code/tc_fix.do). No-ops for any
# other year -- applied unconditionally per year, matching the existing
# reweight_years-style conditional pattern already used for cmpwgt/orgwgt.
# Only weekpay/wage are corrected; wageotc's rebuild is skipped per scope
# decision (wageotc isn't ported in this pilot).

# tc_weekpay (topcode flag, internal-only -- needed only to know which rows
# tc_fix should touch). Proven equivalent to Stata's own (ordering-ambiguous)
# generate_tc_weekpay.do logic: weekpay >= threshold and weekpay_noadj >=
# threshold are mathematically identical whenever threshold <= topcodeval,
# since the Pareto-imputed mean is always >= topcodeval. For 2023m4+ there's
# no fixed numeric ceiling anymore, so use the literal BLS-supplied flag ptwk.
compute_tc_weekpay <- function(weekpay_noadj, ptwk, year, month) {
  dplyr::if_else(
    (year == 2023 & month >= 4) | year >= 2024,
    as.numeric(ptwk),
    dplyr::if_else(!is.na(weekpay_noadj) & weekpay_noadj >= 2884.60, 1, 0, missing = 0)
  )
}

#' Reference male_tc/female_tc constants used only for 2023's Jan-Mar
#' correction: Pareto-impute weekpay_noadj on a 2023 Jan-Mar-only ORG
#' subsample (drop minsamp==4 rows from month>=4, i.e. the already-rolled-out
#' respondents), by sex.
compute_tc_constants <- function(org_2023_pretopcode) {
  d <- org_2023_pretopcode |> dplyr::filter(!(minsamp == 4 & month >= 4))
  compute_one <- function(sex) {
    s <- d |> dplyr::filter(female == sex, !is.na(weekpay_noadj), !is.na(age), age >= 16)
    res <- topcode_impute_pareto(s$weekpay_noadj, s$orgwgt, threshold = 80, topcodeval = 2884.60)
    res$newmeanabove
  }
  list(male_tc = compute_one(0), female_tc = compute_one(1))
}

#' Apply the tc_fix.do correction to an already wage-assembled ORG-year table.
#' No-op for any year other than 2023/2024.
apply_tc_fix <- function(org_year, tc_constants, wage_bounds) {
  year <- unique(org_year$year)
  if (!(year %in% c(2023, 2024))) return(org_year)

  d <- org_year
  d$tc_weekpay <- compute_tc_weekpay(d$weekpay_noadj, d$ptwk, d$year, d$month)
  d$weekpay <- d$weekpay_noadj  # reset, per tc_fix.do

  wtd_mean <- function(x, w) sum(x * w) / sum(w)

  if (year == 2023) {
    # months 1-3: still under the old fixed-ceiling regime -- replace with the
    # sex-specific Pareto constant computed from the Jan-Mar-only subsample
    idx13 <- d$month <= 3 & d$tc_weekpay == 1
    d$weekpay[idx13 & d$female == 0] <- tc_constants$male_tc
    d$weekpay[idx13 & d$female == 1] <- tc_constants$female_tc

    # months 4-12: Census's dynamic top-code rollout, phased in by rotation
    # group -- minsamp==4 (incoming) gets the new dynamic code first that
    # month; minsamp==8 (still outgoing) is corrected via a weighted mean of
    # minsamp==4 respondents at/above the old fixed ceiling that month
    for (m in 4:12) {
      idx4 <- d$tc_weekpay == 1 & d$minsamp == 4 & d$month == m
      d$weekpay[idx4] <- max(d$weekpay_noadj[d$month == m], na.rm = TRUE)

      idx8 <- d$tc_weekpay == 1 & d$minsamp == 8 & d$month == m
      sub <- d[d$month == m & !is.na(d$weekpay_noadj) & d$weekpay_noadj >= 2884.6 & d$minsamp == 4, ]
      d$weekpay[idx8] <- wtd_mean(sub$weekpay_noadj, sub$orgwgt)
    }
  } else {
    # 2024 months 1-3: same dynamic phase-in split as 2023's months 4-12
    for (m in 1:3) {
      idx4 <- d$tc_weekpay == 1 & d$minsamp == 4 & d$month == m
      d$weekpay[idx4] <- max(d$weekpay_noadj[d$month == m], na.rm = TRUE)

      idx8 <- d$tc_weekpay == 1 & d$minsamp == 8 & d$month == m
      sub <- d[d$month == m & !is.na(d$weekpay_noadj) & d$weekpay_noadj >= 2884.6 & d$minsamp == 4, ]
      d$weekpay[idx8] <- wtd_mean(sub$weekpay_noadj, sub$orgwgt)
    }
    # 2024 months 4-12: fully standardized dynamic top-code -- just use that
    # month's raw max, no rotation-group split needed
    for (m in 4:12) {
      idx <- d$tc_weekpay == 1 & d$month == m
      d$weekpay[idx] <- max(d$weekpay_noadj[d$month == m], na.rm = TRUE)
    }
  }

  # rebuild wage from the corrected weekpay using the same formula as the
  # standard flow, then re-trim; wageotc rebuild intentionally skipped
  add_wage(d, wage_bounds)
}
