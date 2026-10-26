# Pipeline configuration: config/pipeline.yml (paths, years, skipped months)
# and config/release.yml (version). Everything else reads settings from here.

#' Read config/pipeline.yml and resolve relative paths against the repo root
#' (the folder above config/).
read_pipeline_config <- function(config_file) {
  repo_root <- dirname(dirname(normalizePath(config_file)))
  config <- yaml::read_yaml(config_file)
  # absolute paths stay as they are; relative ones hang off the repo root
  config$paths <- purrr::map(config$paths, ~ if (startsWith(.x, "/")) .x else file.path(repo_root, .x))
  config$years <- seq(config$years$first, config$years$last)
  config$reweight_years <- seq(config$reweight_years$first, config$reweight_years$last)
  config
}

#' Months to process for one year: 1-12 minus skipped months (e.g. 2025m10).
#' Shared with the Stata loader and epiextractr, which hardcode the same gap.
year_months <- function(year, skip_months) {
  months <- 1:12
  months[!paste0(year, "m", months) %in% skip_months]
}

#' Data label written into every extract, e.g. "EPI CPS Basic Monthly Extracts,
#' Version 2026.10.13" (same wording as the Stata-made files).
data_label <- function(sample, release_file) {
  version <- yaml::read_yaml(release_file)$version
  sample_name <- c(basic = "Basic Monthly", org = "ORG")[[sample]]
  paste0("EPI CPS ", sample_name, " Extracts, Version ", version)
}
