source("./packages.R")
lapply(list.files("./R", full.names = TRUE), source)

## CONFIGURATION
# Stable settings (paths, first year, skipped months): ../config/pipeline.yml.
# The latest month (../config/release.yml) only reaches targets through
# `years` and `year_spec`, so a new release rebuilds just the current year
# (see R/config.R). The version reaches them through release_version.
pipeline_config_file <- "../config/pipeline.yml"
config <- read_pipeline_config(pipeline_config_file)
release_month <- read_release_month("../config/release.yml")
latest_march <- read_latest_march("../config/release.yml")
worker_settings <- read_worker_settings(pipeline_config_file)
output_dir <- read_output_dir(pipeline_config_file)

# variable registry: what to compute and export (see R/registry.R)
registry <- read_registry("variables.csv")
recode_functions <- registry_functions(registry)
value_labels <- readr::read_csv("value_labels.csv", col_types = "cdc", trim_ws = FALSE)

tar_option_set(
  format = "parquet",
  controller = crew::crew_controller_local(
    workers = worker_settings$workers,
    # a fresh worker process per target: memory left over from earlier
    # targets would otherwise build up against the cap
    tasks_max = worker_settings$worker_tasks_max,
    # cap each worker's memory as it starts, so a runaway worker errors out
    # instead of exhausting the shared server
    r_arguments = c("--no-save", "--no-restore", "-e", worker_memory_limit(worker_settings$worker_memory_gb))
  )
)

tar_assign({
  ###############
  # INPUT FILES #
  ###############
  release_file = "../config/release.yml" |>
    tar_file()

  # only the version reaches the files: other release.yml edits rebuild nothing
  release_version = read_release_version(release_file) |>
    tar_target(format = "rds")

  cpi_file = file.path(config$paths$suppdata, "cpiurs_extended.csv") |>
    tar_file()

  cpi_projection_file = "../config/cpi_projection.yml" |>
    tar_file()

  geocodes_file = file.path(config$paths$suppdata, "state_geocodes.csv") |>
    tar_file()

  mocc10_file = "crosswalks/mocc10.csv" |>
    tar_file()

  parity_exceptions_file = "parity_exceptions.csv" |>
    tar_file()

  # Stata notes for each variable (written into the .dta files)
  notes_file = "variable_notes.csv" |>
    tar_file()

  telework_zips = telework_zip_paths(config) |>
    tar_target(format = "file")

  years = pipeline_years(config, release_month) |>
    tar_target(format = "rds")

  # per year: its months, whether it's partial, its trailing-window months.
  # Recomputed every release, but only the latest year's value changes.
  year_spec = build_year_spec(years, config, release_month) |>
    tar_target(pattern = map(years), iteration = "list", format = "rds")

  raw_zips = raw_zip_paths(year_spec, config) |>
    tar_target(pattern = map(year_spec), format = "file")

  reference_basic_dta = reference_dta_path(year_spec, "basic", config) |>
    tar_target(pattern = map(year_spec), format = "file")

  reference_org_dta = reference_dta_path(year_spec, "org", config) |>
    tar_target(pattern = map(year_spec), format = "file")

  ###################
  # PROCESS RAW DATA #
  ###################
  # every column of every month, parsed once into cache/raw/; recoding reads
  # only the columns it needs, so adding variables never re-parses raw files
  raw_parquet = parse_raw_year(year_spec, raw_zips, config) |>
    tar_target(pattern = map(year_spec, raw_zips), format = "file")

  # telework supplement, 2022m10-2024m5: its own cache, joined when reading raw months
  telework_parquet = parse_telework(telework_zips, config) |>
    tar_target(format = "file")

  state_geocodes = build_state_geocodes(geocodes_file) |>
    tar_target()

  mocc10_crosswalk = read_mocc10_crosswalk(mocc10_file) |>
    tar_target()

  cpi = cpi_annual_fun(cpi_file, cpi_projection_file) |>
    tar_target()

  wage_bounds = build_wage_bounds(cpi) |>
    tar_target()

  recode_context = list(
      reweight_years = config$reweight_years,
      state_geocodes = state_geocodes,
      wage_bounds = wage_bounds,
      mocc10_crosswalk = mocc10_crosswalk,
      telework_files = telework_parquet
    ) |>
    tar_target(format = "rds")

  basic_year = recode_basic_year(raw_parquet, registry, recode_functions, recode_context) |>
    tar_target(pattern = map(raw_parquet))

  # a partial year's trailing window: the previous year's months, recoded.
  # Empty for full years, so only the partial year depends on other years' raw files.
  trailing_basic = recode_trailing_window(year_spec, raw_parquet, registry, recode_functions, recode_context) |>
    tar_target(pattern = map(year_spec))

  # the wage adjustments run on each sample's own table, as adjust_wages.do does;
  # the year's raw files hold the separate ORG files of 1979-1983
  basic_extract = build_extract_year(basic_year, trailing_basic, raw_parquet, registry, recode_functions, recode_context, "basic") |>
    tar_target(pattern = map(basic_year, trailing_basic, raw_parquet))

  org_extract = build_extract_year(basic_year, trailing_basic, raw_parquet, registry, recode_functions, recode_context, "org") |>
    tar_target(pattern = map(basic_year, trailing_basic, raw_parquet))

  ##########
  # PARITY #
  ##########
  reference_basic_parquet = cache_reference_year(reference_basic_dta, config$paths$cache) |>
    tar_target(pattern = map(reference_basic_dta), format = "file")

  reference_org_parquet = cache_reference_year(reference_org_dta, config$paths$cache) |>
    tar_target(pattern = map(reference_org_dta), format = "file")

  reference_basic_meta = reference_metadata(reference_basic_dta) |>
    tar_target(pattern = map(reference_basic_dta), iteration = "list", format = "rds")

  reference_org_meta = reference_metadata(reference_org_dta) |>
    tar_target(pattern = map(reference_org_dta), iteration = "list", format = "rds")

  parity_exceptions = read_parity_exceptions(parity_exceptions_file) |>
    tar_target()

  # compares the released .feather files column by column (low memory)
  parity_basic_values = compare_values_year(basic_feather, reference_basic_parquet, registry, "basic", parity_exceptions) |>
    tar_target(pattern = map(basic_feather, reference_basic_parquet))

  parity_org_values = compare_values_year(org_feather, reference_org_parquet, registry, "org", parity_exceptions) |>
    tar_target(pattern = map(org_feather, reference_org_parquet))

  parity_basic_metadata = compare_metadata_year(reference_basic_meta, registry, value_labels, "basic",
                                                years, data_label("basic", release_version)) |>
    tar_target(pattern = map(reference_basic_meta, years))

  parity_org_metadata = compare_metadata_year(reference_org_meta, registry, value_labels, "org",
                                              years, data_label("org", release_version)) |>
    tar_target(pattern = map(reference_org_meta, years))

  parity_values_csv = create_csv(dplyr::bind_rows(parity_basic_values, parity_org_values, parity_may_values, parity_march_values),
                                 file.path(config$paths$reports, "parity_values.csv")) |>
    tar_file()

  parity_metadata_csv = create_csv(dplyr::bind_rows(parity_basic_metadata, parity_org_metadata, parity_may_metadata, parity_march_metadata),
                                   file.path(config$paths$reports, "parity_metadata.csv")) |>
    tar_file()

  # fails the build on any mismatch; runs after both reports are written
  parity_summary = parity_gate(
      dplyr::bind_rows(parity_basic_values, parity_org_values, parity_may_values, parity_march_values),
      dplyr::bind_rows(parity_basic_metadata, parity_org_metadata, parity_may_metadata, parity_march_metadata)
    ) |>
    tar_target()

  #################
  # FINAL RELEASE #
  #################
  # one file per year; one per month for a partial year
  variable_notes = readr::read_csv(notes_file, col_types = "ccic") |>
    tar_target()

  basic_feather = label_extract(basic_extract, registry, value_labels, "basic", data_label("basic", release_version)) |>
    write_extract("basic", output_dir, year_spec) |>
    tar_target(pattern = map(basic_extract, year_spec), format = "file")

  org_feather = label_extract(org_extract, registry, value_labels, "org", data_label("org", release_version)) |>
    write_extract("org", output_dir, year_spec) |>
    tar_target(pattern = map(org_extract, year_spec), format = "file")

  # Stata .dta (format 117, as saveold version(13) writes): storage types,
  # labels and notes as in the Stata-made files. The wages-stage variables
  # stay float, as they're created after Stata's compress (R/dta.R).
  basic_dta = label_extract(basic_extract, registry, value_labels, "basic", data_label("basic", release_version)) |>
    write_extract("basic", output_dir, year_spec, "dta", notes_for(variable_notes, "basic"),
                  uncompressed = registry$variable[registry$stage == "wages"],
                  integer_vars = registry$variable[registry$stata_type == "integer"]) |>
    tar_target(pattern = map(basic_extract, year_spec), format = "file")

  org_dta = label_extract(org_extract, registry, value_labels, "org", data_label("org", release_version)) |>
    write_extract("org", output_dir, year_spec, "dta", notes_for(variable_notes, "org"),
                  uncompressed = registry$variable[registry$stage == "wages"],
                  integer_vars = registry$variable[registry$stata_type == "integer"]) |>
    tar_target(pattern = map(org_extract, year_spec), format = "file")

  #######
  # MAY #
  #######
  # May supplement, 1973-1981: one Unicon file per year, its own functions
  # (source unicon_may), the wage stage, and its own parity checks. Stata
  # compresses May after the wage stage, so nothing stays uncompressed
  may_years = config$may_years |>
    tar_target(format = "rds")

  may_zip = may_zip_path(may_years, config) |>
    tar_target(pattern = map(may_years), format = "file")

  may_raw = cache_may_year(may_zip, config) |>
    tar_target(pattern = map(may_zip), format = "file")

  may_extract = build_may_year(may_raw, registry, recode_functions, recode_context) |>
    tar_target(pattern = map(may_raw))

  may_feather = label_extract(may_extract, registry, value_labels, "may", data_label("may", release_version)) |>
    write_extract("may", output_dir, annual_spec(may_years)) |>
    tar_target(pattern = map(may_extract, may_years), format = "file")

  may_dta = label_extract(may_extract, registry, value_labels, "may", data_label("may", release_version)) |>
    write_extract("may", output_dir, annual_spec(may_years), "dta", notes_for(variable_notes, "may"),
                  integer_vars = registry$variable[registry$stata_type == "integer"]) |>
    tar_target(pattern = map(may_extract, may_years), format = "file")

  reference_may_dta = reference_dta_path(annual_spec(may_years), "may", config) |>
    tar_target(pattern = map(may_years), format = "file")

  reference_may_parquet = cache_reference_year(reference_may_dta, config$paths$cache) |>
    tar_target(pattern = map(reference_may_dta), format = "file")

  reference_may_meta = reference_metadata(reference_may_dta) |>
    tar_target(pattern = map(reference_may_dta), iteration = "list", format = "rds")

  parity_may_values = compare_values_year(may_feather, reference_may_parquet, registry, "may", parity_exceptions) |>
    tar_target(pattern = map(may_feather, reference_may_parquet))

  parity_may_metadata = compare_metadata_year(reference_may_meta, registry, value_labels, "may",
                                              may_years, data_label("may", release_version)) |>
    tar_target(pattern = map(reference_may_meta, may_years))

  #########
  # MARCH #
  #########
  # March (ASEC), 1962 to latestmarch: one input file per year (2014: two
  # samples), sources unicon_march/census_march, no wage stage
  march_years = seq(config$march_first_year, latest_march) |>
    tar_target(format = "rds")

  march_zips = march_zip_paths(march_years, config) |>
    tar_target(pattern = map(march_years), format = "file")

  march_raw = cache_march_year(march_zips, config) |>
    tar_target(pattern = map(march_zips), format = "file")

  march_extract = build_march_year(march_raw, registry, recode_functions, recode_context) |>
    tar_target(pattern = map(march_raw))

  march_feather = label_extract(march_extract, registry, value_labels, "march", data_label("march", release_version)) |>
    write_extract("march", output_dir, annual_spec(march_years, 3)) |>
    tar_target(pattern = map(march_extract, march_years), format = "file")

  march_dta = label_extract(march_extract, registry, value_labels, "march", data_label("march", release_version)) |>
    write_extract("march", output_dir, annual_spec(march_years, 3), "dta", notes_for(variable_notes, "march"),
                  integer_vars = registry$variable[registry$stata_type == "integer"]) |>
    tar_target(pattern = map(march_extract, march_years), format = "file")

  reference_march_dta = reference_dta_path(annual_spec(march_years, 3), "march", config) |>
    tar_target(pattern = map(march_years), format = "file")

  reference_march_parquet = cache_reference_year(reference_march_dta, config$paths$cache) |>
    tar_target(pattern = map(reference_march_dta), format = "file")

  reference_march_meta = reference_metadata(reference_march_dta) |>
    tar_target(pattern = map(reference_march_dta), iteration = "list", format = "rds")

  parity_march_values = compare_values_year(march_feather, reference_march_parquet, registry, "march", parity_exceptions) |>
    tar_target(pattern = map(march_feather, reference_march_parquet))

  parity_march_metadata = compare_metadata_year(reference_march_meta, registry, value_labels, "march",
                                                march_years, data_label("march", release_version)) |>
    tar_target(pattern = map(reference_march_meta, march_years))
})
