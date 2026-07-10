# Stata's round() rounds half away from zero; R's round() uses banker's
# rounding (round half to even). Any port of Stata round()/bin-rounding logic
# must use this instead of base round() to avoid mismatches at .5 boundaries.
stata_round <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5) / scale
}

create_feather <- function(data, file) {
  fs::dir_create(fs::path_dir(file))
  arrow::write_feather(data, file)
  file
}

create_csv <- function(data, file) {
  fs::dir_create(fs::path_dir(file))
  readr::write_csv(data, file)
  file
}
