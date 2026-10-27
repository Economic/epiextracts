# Pipeline configuration: config/pipeline.yml (paths, first year, skipped
# months) and config/release.yml (version, latest month of data). Everything
# else reads settings from here.

#' Read config/pipeline.yml and config/release.yml (both in the config/
#' folder) and resolve relative paths against the repo root.
read_pipeline_config <- function(config_file) {
  repo_root <- dirname(dirname(normalizePath(config_file)))
  config <- yaml::read_yaml(config_file)
  release <- yaml::read_yaml(file.path(dirname(config_file), "release.yml"))

  # absolute paths stay as they are; relative ones hang off the repo root
  config$paths <- purrr::map(config$paths, ~ if (startsWith(.x, "/")) .x else file.path(repo_root, .x))

  # the latest month of data ("2026m9") ends the year range
  latest <- as.integer(strsplit(release$latestdata, "m")[[1]])
  config$latest_year <- latest[1]
  config$latest_month <- latest[2]
  config$years <- seq(config$first_year, config$latest_year)
  config$reweight_years <- seq(config$reweight_years$first, config$reweight_years$last)
  config
}

#' Months with data in one year: 1-12, minus skipped months (e.g. 2025m10),
#' and only through the latest month in the latest year. The Stata loader
#' and epiextractr hardcode the same October 2025 gap.
year_months <- function(year, config) {
  months <- 1:12
  if (year == config$latest_year) months <- months[months <= config$latest_month]
  months[!paste0(year, "m", months) %in% config$skip_months]
}

#' A partial year is the latest year before its December data is out. Its
#' extracts are monthly files, and its wage adjustments use a trailing
#' 12-month window (create_extracts.ado).
is_partial_year <- function(year, config) {
  year == config$latest_year && config$latest_month < 12
}

#' Data label written into every extract, e.g. "EPI CPS Basic Monthly Extracts,
#' Version 2026.10.13" (same wording as the Stata-made files).
data_label <- function(sample, release_file) {
  version <- yaml::read_yaml(release_file)$version
  sample_name <- c(basic = "Basic Monthly", org = "ORG")[[sample]]
  paste0("EPI CPS ", sample_name, " Extracts, Version ", version)
}
