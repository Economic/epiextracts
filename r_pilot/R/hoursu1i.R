# Internal-only inputs to hoursu1i's imputation (generate_hoursu1i.do). These
# 8 covariates are NOT exposed in pilot output or individually parity-checked
# (per explicit scope decision) -- they exist purely to make the regression
# design matrix match Stata's. Full 2000-2024 era-branching is ported (not
# just a single spot-validated era) since a wrong covariate for ~18 of 25
# years would materially degrade the hoursu1i imputation.

# --- educ (generate_educ.do), 1994+ ----------------------------------------
recode_educ <- function(peeduca) {
  dplyr::case_when(
    peeduca >= 31 & peeduca <= 38 ~ 1,
    peeduca == 39                 ~ 2,
    peeduca >= 40 & peeduca <= 42 ~ 3,
    peeduca == 43                 ~ 4,
    peeduca >= 44 & peeduca <= 46 ~ 5,
    TRUE                          ~ NA_real_
  )
}

# --- hispanic (generate_hispanic.do), 1994+ --------------------------------
# Baseline 0 (never missing), matching Stata's `gen hispanic = 0` then
# replace-to-1 pattern -- source column renamed 1994-2002 -> 2003+.
recode_hispanic <- function(year, prorigin, prdthsp) {
  dplyr::case_when(
    year <= 2002                   ~ dplyr::if_else(!is.na(prorigin) & prorigin >= 1 & prorigin <= 7, 1, 0),
    year >= 2003 & year <= 2013    ~ dplyr::if_else(!is.na(prdthsp) & prdthsp >= 1 & prdthsp <= 5, 1, 0),
    year >= 2014                   ~ dplyr::if_else(!is.na(prdthsp) & prdthsp >= 1 & prdthsp <= 8, 1, 0),
    TRUE                           ~ 0
  )
}

# --- wbho (generate_wbho.do), 1994+ ----------------------------------------
# Race source column/coding changes at 2003 and again at 2012m5; ptdtrace was
# renamed prdtrace for a ~15-month window (May 2004-Jul 2005), same pattern as
# peage/prtage -- coalesce() handles it. Hispanic ethnicity always overrides.
recode_wbho <- function(year, month, perace, ptdtrace, prdtrace, hispanic) {
  ptdtrace_eff <- dplyr::coalesce(as.numeric(ptdtrace), as.numeric(prdtrace))
  is_pre2003    <- year <= 2002
  is_2003_2012a <- year >= 2003 & (year < 2012 | (year == 2012 & month <= 4))
  is_2012b_on   <- year > 2012 | (year == 2012 & month >= 5)

  race <- dplyr::case_when(
    is_pre2003 & perace == 1 ~ 1,
    is_pre2003 & perace == 2 ~ 2,
    is_pre2003 & perace >= 3 & perace <= 4 ~ 4,

    is_2003_2012a & ptdtrace_eff == 1 ~ 1,
    is_2003_2012a & (ptdtrace_eff == 2 | ptdtrace_eff %in% c(6, 10, 11, 12, 15, 16, 19)) ~ 2,
    is_2003_2012a & ((ptdtrace_eff >= 3 & ptdtrace_eff <= 5) |
                       ptdtrace_eff %in% c(7, 8, 9, 13, 14, 17, 18, 20, 21)) ~ 4,

    is_2012b_on & ptdtrace_eff == 1 ~ 1,
    is_2012b_on & (ptdtrace_eff == 2 | ptdtrace_eff %in% c(6, 10, 11, 12, 16, 17, 18, 22, 23)) ~ 2,
    is_2012b_on & ((ptdtrace_eff >= 3 & ptdtrace_eff <= 5) |
                     ptdtrace_eff %in% c(7, 8, 9, 13, 14, 15, 19, 20, 21, 24, 25, 26)) ~ 4,

    TRUE ~ NA_real_
  )
  dplyr::if_else(hispanic == 1, 3, race, missing = race)
}

# --- citistat (generate_citistat.do), 1994+ --------------------------------
recode_citistat <- function(prcitshp) as.numeric(prcitshp)

# --- married (generate_married.do), 1994+ ----------------------------------
recode_married <- function(prmarsta) {
  dplyr::case_when(
    prmarsta >= 4 & prmarsta <= 7 ~ 0,
    prmarsta >= 1 & prmarsta <= 3 ~ 1,
    TRUE                          ~ NA_real_
  )
}

# --- statefips (generate_statefips.do), 1994+ ------------------------------
# Stata's script also merges in state_geocodes.csv, but only for value
# labels/region -- irrelevant here since statefips is a regression covariate.
recode_statefips_aux <- function(gestfips) as.numeric(gestfips)

# --- unmem/uncov/union (generate_unmem.do, generate_uncov.do,
# generate_union.do), 1994+, ORG context (earnerinfo==1, basicfile==0) -----
# IMPORTANT: dplyr::if_else()'s default NA-propagation does NOT match Stata's
# `replace x = y if cond` (which leaves x unchanged when cond is missing/false)
# -- every sequential replace-if here MUST pass missing = <current value>,
# or NA condition values silently corrupt rows instead of leaving them as-is.
recode_union <- function(peernlab, peerncov) {
  unmem <- dplyr::case_when(peernlab == 2 ~ 0, peernlab == 1 ~ 1, TRUE ~ NA_real_)
  uncov <- dplyr::case_when(peerncov == 2 ~ 0, peerncov == 1 ~ 1, TRUE ~ NA_real_)
  union <- dplyr::case_when(!is.na(unmem) | !is.na(uncov) ~ 0, TRUE ~ NA_real_)
  union <- dplyr::if_else(unmem == 1, 1, union, missing = union)
  union <- dplyr::if_else(uncov == 1, 1, union, missing = union)
  union
}

# --- pubsec (generate_pubsec.do), 1994+ ------------------------------------
recode_pubsec <- function(peio1cow) {
  pubsec <- dplyr::case_when(peio1cow >= 1 & !is.na(peio1cow) ~ 0, TRUE ~ NA_real_)
  dplyr::if_else(peio1cow >= 1 & peio1cow <= 3, 1, pubsec, missing = pubsec)
}

# --- indcode (generate_indcode.do), 1994+ ----------------------------------
recode_indcode <- function(peio1icd) {
  indcode <- as.numeric(peio1icd)
  dplyr::if_else(indcode < 0, NA_real_, indcode)
}

# --- mind16 (generate_mind16.do) -------------------------------------------
# Major-industry bucket boundaries differ between the pre-2003 (3-digit,
# "ind90"-era) and 2003+ (4-digit) industry code systems; a 2020+ hospital
# code carve-out (8191/8192) is nested inside the 2003+ branch.
recode_mind16 <- function(indcode, year) {
  yr <- unique(year)
  if (yr <= 2002) {
    dplyr::case_when(
      indcode == 991 ~ NA_real_,
      (indcode >= 10 & indcode <= 19) | (indcode >= 21 & indcode <= 30) |
        (indcode >= 31 & indcode <= 32) | (indcode >= 40 & indcode <= 50) ~ 1,
      indcode == 60 ~ 2,
      (indcode >= 230 & indcode <= 392) ~ 3,
      (indcode >= 100 & indcode <= 222) ~ 4,
      (indcode >= 400 & indcode <= 432) ~ 5,
      (indcode >= 440 & indcode <= 442) | (indcode >= 450 & indcode <= 472) ~ 6,
      (indcode >= 500 & indcode <= 571) ~ 7,
      (indcode >= 580 & indcode <= 640) | (indcode >= 642 & indcode <= 691) ~ 8,
      indcode == 841 | (indcode >= 700 & indcode <= 712) | (indcode >= 721 & indcode <= 760) |
        indcode == 20 | (indcode >= 873 & indcode <= 893) ~ 9,
      indcode == 761 | (indcode >= 771 & indcode <= 791) ~ 10,
      indcode == 872 | indcode == 641 | indcode == 762 | indcode == 770 |
        (indcode >= 800 & indcode <= 810) ~ 11,
      indcode == 831 ~ 12,
      (indcode >= 812 & indcode <= 830) | (indcode >= 832 & indcode <= 840) ~ 13,
      (indcode >= 842 & indcode <= 860) ~ 14,
      (indcode >= 861 & indcode <= 871) ~ 15,
      (indcode >= 900 & indcode <= 932) ~ 16,
      TRUE ~ NA_real_
    )
  } else {
    dplyr::case_when(
      indcode == 9890 ~ NA_real_,
      (indcode >= 170 & indcode <= 180) | indcode == 290 | indcode == 7480 |
        (indcode >= 190 & indcode <= 280) | (indcode >= 370 & indcode <= 490) ~ 1,
      indcode == 770 ~ 2,
      (indcode >= 2470 & indcode <= 3990) ~ 3,
      (indcode >= 1070 & indcode <= 2390) | (indcode >= 6470 & indcode <= 6481) ~ 4,
      (indcode >= 6070 & indcode <= 6390) ~ 5,
      (indcode >= 570 & indcode <= 690) | (indcode >= 6490 & indcode <= 6695) |
        (indcode >= 6780 & indcode <= 6790) ~ 6,
      (indcode >= 4070 & indcode <= 4590) ~ 7,
      (indcode >= 4670 & indcode <= 5791) ~ 8,
      (indcode >= 6870 & indcode <= 7190) | (indcode >= 7270 & indcode <= 7470) |
        (indcode >= 7490 & indcode <= 7790) | (indcode >= 8770 & indcode <= 8891) |
        (indcode >= 9160 & indcode <= 9190) ~ 9,
      indcode == 9290 | (indcode >= 8970 & indcode <= 9090) ~ 10,
      (indcode >= 8560 & indcode <= 8690) ~ 11,
      indcode == 8190 | (indcode == 8191 & yr >= 2020) | (indcode == 8192 & yr >= 2020) ~ 12,
      (indcode >= 7970 & indcode <= 8180) | (indcode >= 8270 & indcode <= 8290) ~ 13,
      indcode == 6770 | (indcode >= 7860 & indcode <= 7890) ~ 14,
      (indcode >= 8370 & indcode <= 8470) ~ 15,
      (indcode >= 9370 & indcode <= 9590) ~ 16,
      TRUE ~ NA_real_
    )
  }
}

#' Compute the 8 internal-only covariates from a year's raw table.
compute_aux_covariates <- function(raw_year) {
  raw_year |>
    dplyr::transmute(
      hrhhid,
      hhid = as.numeric(qstnum), personid = as.numeric(occurnum),
      year = hryear4, month = hrmonth,
      educ = recode_educ(peeduca),
      hispanic = recode_hispanic(hryear4, prorigin, prdthsp),
      wbho = recode_wbho(hryear4, hrmonth, perace, ptdtrace, prdtrace, hispanic),
      citistat = recode_citistat(prcitshp),
      married = recode_married(prmarsta),
      statefips = recode_statefips_aux(gestfips),
      union = recode_union(peernlab, peerncov),
      pubsec = recode_pubsec(peio1cow),
      indcode = recode_indcode(peio1icd),
      mind16 = recode_mind16(indcode, hryear4)
    ) |>
    dplyr::select(-hispanic, -indcode)
}

# --- regression design matrix + 4-way fit/predict --------------------------
# Explicit design-matrix construction (not lm(formula=...)) so the factor
# reference category (lowest value present in the TRAINING subsample) matches
# Stata's `i.` convention exactly, and unseen prediction-row factor levels
# fall back to the base category (all dummies 0) rather than erroring, again
# matching Stata's predict/xb behavior on out-of-sample categorical values.
build_design <- function(data, factor_vars, levels_list = NULL) {
  row_missing <- is.na(data$age)
  X <- cbind(`(Intercept)` = 1, age = data$age, age2 = data$age^2,
             age3 = data$age^3, age4 = data$age^4, age5 = data$age^5)
  levels_used <- list()
  for (v in factor_vars) {
    vals <- data[[v]]
    row_missing <- row_missing | is.na(vals)
    lv <- if (is.null(levels_list)) sort(unique(vals[!is.na(vals)])) else levels_list[[v]]
    base <- min(lv)
    for (lev in lv[lv != base]) {
      X <- cbind(X, ifelse(!is.na(vals) & vals == lev, 1, 0))
      colnames(X)[ncol(X)] <- paste0(v, "_", lev)
    }
    levels_used[[v]] <- lv
  }
  list(X = X, levels_used = levels_used, row_missing = row_missing)
}

fit_predict_hours <- function(d, sex, band_fit, band_pred, factor_vars) {
  train <- d[d$orgsample & d$female == sex & !is.na(d$hoursu1) & d$hoursu1 > 0 &
               d$hoursuint >= band_fit[1] & d$hoursuint <= band_fit[2], ]
  train <- train[stats::complete.cases(train[, factor_vars]) & !is.na(train$age), ]

  des <- build_design(train, factor_vars)
  fit <- stats::lm.wfit(x = des$X, y = train$hoursu1, w = train$orgwgt)

  pred_rows <- d[d$orgsample & d$female == sex & d$hoursuint == band_pred, ]
  des_pred <- build_design(pred_rows, factor_vars, levels_list = des$levels_used)
  Xp <- des_pred$X[, colnames(des$X), drop = FALSE]
  pred <- as.numeric(Xp %*% fit$coefficients)
  pred[des_pred$row_missing] <- NA_real_

  data.frame(obs_id = pred_rows$obs_id, pred = pred)
}

#' Compute hoursu1i for an ORG-year table (joins in the 8 aux covariates from
#' raw_year internally, then drops them before returning).
compute_hoursu1i <- function(org_year, raw_year) {
  aux <- compute_aux_covariates(raw_year)
  d <- dplyr::inner_join(org_year, aux, by = c("hrhhid", "hhid", "personid", "year", "month"))

  factor_vars <- c("educ", "wbho", "citistat", "married", "statefips", "union", "pubsec", "mind16")
  d$orgsample <- !is.na(d$orgwgt) & d$orgwgt > 0 & !is.na(d$age) & d$age >= 16 &
    (d$minsamp == 4 | d$minsamp == 8)
  d$obs_id <- seq_len(nrow(d))

  preds <- dplyr::bind_rows(
    fit_predict_hours(d, sex = 1, band_fit = c(3, 6), band_pred = 7, factor_vars),
    fit_predict_hours(d, sex = 1, band_fit = c(1, 2), band_pred = 8, factor_vars),
    fit_predict_hours(d, sex = 0, band_fit = c(3, 6), band_pred = 7, factor_vars),
    fit_predict_hours(d, sex = 0, band_fit = c(1, 2), band_pred = 8, factor_vars)
  )

  d <- dplyr::left_join(d, preds, by = "obs_id")
  d$hoursu1i <- dplyr::if_else(!is.na(d$hoursu1), d$hoursu1, d$pred)
  d$hoursu1i <- stata_round(d$hoursu1i)
  d$hoursu1i <- dplyr::if_else(!is.na(d$hoursu1i) & d$hoursu1i > 99, 99, d$hoursu1i, missing = d$hoursu1i)
  d$hoursu1i <- dplyr::if_else(!is.na(d$hoursu1i) & d$hoursu1i < 0, NA_real_, d$hoursu1i, missing = d$hoursu1i)

  d |> dplyr::select(-dplyr::all_of(factor_vars), -orgsample, -obs_id, -pred)
}
