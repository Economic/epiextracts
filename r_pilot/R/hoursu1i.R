# hoursu1i (generate_hoursu1i.do): regression-imputed hours for nonhourly
# workers whose hours vary. The 8 demographic/employment/industry covariates
# it regresses on now live directly on the (basic-level) recoded table --
# see R/demographics.R -- so this file only needs the regression machinery.

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

#' Compute hoursu1i for an ORG-year table. educ/wbho/citistat/married/
#' statefips/union/pubsec/mind16 are already present on org_year (inherited
#' from recode_year() via filter_org_universe()) -- no join needed.
compute_hoursu1i <- function(org_year) {
  d <- org_year
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

  d |> dplyr::select(-orgsample, -obs_id, -pred)
}
