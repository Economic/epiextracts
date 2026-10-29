# Small helpers that reproduce Stata semantics in R.

# Stata's round() rounds half away from zero; R's round() uses banker's
# rounding (round half to even). Any port of Stata round()/bin-rounding logic
# must use this instead of base round() to avoid mismatches at .5 boundaries.
stata_round <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5) / scale
}

# Stata's `replace x = value if cond`: rows where cond is false OR missing
# keep their current value (dplyr::if_else would make them NA).
stata_replace <- function(x, cond, value) {
  hit <- !is.na(cond) & cond
  x[hit] <- if (length(value) == 1) value else value[hit]
  x
}

# Stata treats missing as larger than any number, so an unguarded `x >= 0`
# is true for missing x. Compare as_stata(x) where the script has no
# `& x ~= .` guard.
as_stata <- function(x) dplyr::coalesce(as.numeric(x), Inf)

# Months as one number, for date windows: ym(year, month) >= ym(2004, 5)
# is Stata's $date >= tm(2004m5).
ym <- function(year, month) year * 12 + month

# Raw value where the date window applies, otherwise missing (passthrough
# variables that only exist for part of the period).
in_window <- function(x, year, month, from = c(1994, 1), to = c(9999, 12)) {
  date <- ym(year, month)
  dplyr::if_else(date >= ym(from[1], from[2]) & date <= ym(to[1], to[2]), as.numeric(x), NA_real_)
}

# Raw value with negative (missing-data) codes set to missing.
nonnegative <- function(x) {
  x <- as.numeric(x)
  dplyr::if_else(x < 0, NA_real_, x)
}

# 0/1 indicator from a Census yes(1)/no(2) item; anything else missing.
yes_no <- function(x) {
  dplyr::case_when(x == 2 ~ 0, x == 1 ~ 1, TRUE ~ NA_real_)
}

# Largest value Stata stores in a float (or any non-double type). Stata
# creates variables as float/byte/int/long, never double, so a computed value
# beyond this becomes missing when stored. Unicon's own "missing" code
# (about 1.75e100, in ernwgt and famwgt from 1985) turns into missing that way.
stata_float_max <- 1.70141173319e38

# a computed value as Stata stores it: missing if beyond float range
stata_store <- function(x) {
  if (!is.numeric(x)) return(x)
  x[!is.na(x) & abs(x) > stata_float_max] <- NA
  x
}
