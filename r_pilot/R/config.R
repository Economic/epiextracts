# Pipeline configuration: config/pipeline.yml (paths, first year, skipped
# months) and config/release.yml (version, latest month of data).
#
# Caching: targets reruns every target whose command mentions an object that
# changed. So `config` holds only settings that rarely change, and the latest
# month reaches the pipeline through one small per-year `year_spec`: each
# release recomputes them all, but only the current year's comes out
# different, so only that year rebuilds.

#' Read config/pipeline.yml and resolve relative paths against the repo root.
#' Release values (latest month, version) are read separately.
read_pipeline_config <- function(config_file) {
  repo_root <- dirname(dirname(normalizePath(config_file)))
  config <- yaml::read_yaml(config_file)

  # worker settings only shape how targets run, not what they compute, and
  # the output folder only where files go; keep them out of the config
  # targets depend on (see read_worker_settings(), read_output_dir())
  config[c(worker_setting_names, "output_dir")] <- NULL

  # absolute paths stay as they are; relative ones hang off the repo root
  config$paths <- purrr::map(config$paths, ~ if (startsWith(.x, "/")) .x else file.path(repo_root, .x))
  config$reweight_years <- seq(config$reweight_years$first, config$reweight_years$last)
  config$may_years <- seq(config$may_years$first, config$may_years$last)
  config
}

#' Latest month of data from config/release.yml ("2026m9").
read_release_month <- function(release_file) {
  latest <- as.integer(strsplit(yaml::read_yaml(release_file)$latestdata, "m")[[1]])
  list(latest_year = latest[1], latest_month = latest[2])
}

#' Years the pipeline builds: the first year through the latest year of data.
pipeline_years <- function(config, release) seq(config$first_year, release$latest_year)

#' Months with data in one year: 1-12, minus skipped months (e.g. 2025m10),
#' and only through the latest month in the latest year. The Stata loader
#' and epiextractr hardcode the same October 2025 gap.
year_months <- function(year, config, release) {
  months <- 1:12
  if (year == release$latest_year) months <- months[months <= release$latest_month]
  months[!paste0(year, "m", months) %in% config$skip_months]
}

#' A partial year is the latest year before its December data is out. Its
#' extracts are monthly files, and its wage adjustments use a trailing
#' 12-month window (create_extracts.ado).
is_partial_year <- function(year, release) {
  year == release$latest_year && release$latest_month < 12
}

#' A year with one annual file and no trailing window (May), in the shape of
#' build_year_spec(), for write_extract() and reference_dta_path().
annual_spec <- function(year, month = 5) list(year = year, months = month, partial = FALSE, window_months = integer(0))

#' Everything about one year that depends on the release: its months,
#' whether it's partial, and, for a partial year, the previous year's months
#' in its trailing window (e.g. 2025m10-m12 for 2026m1-m9, minus skipped
#' months). Unchanged for every year but the latest, release to release.
build_year_spec <- function(year, config, release) {
  months <- year_months(year, config, release)
  partial <- is_partial_year(year, release)
  window_months <- if (partial) intersect(seq(length(months) + 1, 12), year_months(year - 1, config, release)) else integer(0)
  list(year = year, months = months, partial = partial, window_months = window_months)
}

#' The release version from config/release.yml. A target of its own, so
#' editing other release values (or comments) doesn't rewrite every file.
read_release_version <- function(release_file) yaml::read_yaml(release_file)$version

#' Data label written into every extract, e.g. "EPI CPS Basic Monthly Extracts,
#' Version 2026.10.13" (same wording as the Stata-made files).
data_label <- function(sample, version) {
  sample_name <- c(basic = "Basic Monthly", org = "ORG", may = "May")[[sample]]
  paste0("EPI CPS ", sample_name, " Extracts, Version ", version)
}

worker_setting_names <- c("workers", "worker_memory_gb", "worker_tasks_max")

#' Where tar_make() writes the release files (output_dir in
#' config/pipeline.yml), resolved against the repo root. Read apart from
#' read_pipeline_config(), so changing it only rewrites the files.
read_output_dir <- function(config_file) {
  dir <- yaml::read_yaml(config_file)$output_dir
  if (startsWith(dir, "/")) dir else file.path(dirname(dirname(normalizePath(config_file))), dir)
}

#' Worker count, per-worker memory cap and tasks per worker from config/pipeline.yml. Read
#' apart from read_pipeline_config(), so tuning them doesn't make targets
#' rebuild.
read_worker_settings <- function(config_file) {
  yaml::read_yaml(config_file)[worker_setting_names]
}

#' R code that caps a worker process's memory at `gb` gigabytes, run when
#' each crew worker starts (see _targets.R). Over the cap, allocations fail
#' with an error in that worker rather than exhausting the server.
worker_memory_limit <- function(gb) {
  # workers need the unix package; fail here rather than in every worker
  stopifnot(requireNamespace("unix", quietly = TRUE))
  sprintf("unix::rlimit_as(%.0f)", gb * 1e9)
}
