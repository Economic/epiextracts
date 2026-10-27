source("./packages.R")
lapply(list.files("./R", full.names = TRUE), source)

## CONFIGURATION
# settings: ../config/pipeline.yml; version and latest month: ../config/release.yml
pipeline_config_file <- "../config/pipeline.yml"
config <- read_pipeline_config(pipeline_config_file)

# variable registry: what to compute and export (see R/registry.R)
registry <- read_registry("variables.csv")
recode_functions <- registry_functions(registry)
value_labels <- readr::read_csv("value_labels.csv", col_types = "cdc")

tar_option_set(
  format = "parquet",
  controller = crew::crew_controller_local(workers = config$workers)
)

tar_assign({
  ###############
  # INPUT FILES #
  ###############
  pipeline_config_path = pipeline_config_file |>
    tar_file()

  release_file = "../config/release.yml" |>
    tar_file()

  cpi_file = file.path(config$paths$suppdata, "cpiurs_extended.csv") |>
    tar_file()

  cpi_projection_file = "../config/cpi_projection.yml" |>
    tar_file()

  geocodes_file = file.path(config$paths$suppdata, "state_geocodes.csv") |>
    tar_file()

  years = config$years |>
    tar_target(format = "rds")

  raw_zips = raw_zip_paths(years, config) |>
    tar_target(pattern = map(years), format = "file")

  reference_basic_dta = reference_dta_path(years, "basic", config) |>
    tar_target(pattern = map(years), format = "file")

  reference_org_dta = reference_dta_path(years, "org", config) |>
    tar_target(pattern = map(years), format = "file")

  ###################
  # PROCESS RAW DATA #
  ###################
  # every column of every month, parsed once into cache/raw/; recoding reads
  # only the columns it needs, so adding variables never re-parses raw files
  raw_parquet = parse_raw_year(years, raw_zips, config) |>
    tar_target(pattern = map(years, raw_zips), format = "file")

  state_geocodes = build_state_geocodes(geocodes_file) |>
    tar_target()

  cpi = cpi_annual_fun(cpi_file, cpi_projection_file) |>
    tar_target()

  wage_bounds = build_wage_bounds(cpi) |>
    tar_target()

  recode_context = list(
      reweight_years = config$reweight_years,
      state_geocodes = state_geocodes,
      wage_bounds = wage_bounds
    ) |>
    tar_target(format = "rds")

  basic_year = recode_basic_year(raw_parquet, registry, recode_functions, recode_context) |>
    tar_target(pattern = map(raw_parquet))

  # takes every cached raw file: a partial year's trailing window reaches into the year before
  org_year = recode_org_year(basic_year, raw_parquet, registry, recode_functions, recode_context, config) |>
    tar_target(pattern = map(basic_year))

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

  parity_basic_values = compare_values_year(basic_year, reference_basic_parquet, registry, "basic") |>
    tar_target(pattern = map(basic_year, reference_basic_parquet))

  parity_org_values = compare_values_year(org_year, reference_org_parquet, registry, "org") |>
    tar_target(pattern = map(org_year, reference_org_parquet))

  parity_basic_metadata = compare_metadata_year(reference_basic_meta, registry, value_labels, "basic",
                                                years, data_label("basic", release_file)) |>
    tar_target(pattern = map(reference_basic_meta, years))

  parity_org_metadata = compare_metadata_year(reference_org_meta, registry, value_labels, "org",
                                              years, data_label("org", release_file)) |>
    tar_target(pattern = map(reference_org_meta, years))

  parity_values_csv = create_csv(dplyr::bind_rows(parity_basic_values, parity_org_values),
                                 file.path(config$paths$reports, "parity_values.csv")) |>
    tar_file()

  parity_metadata_csv = create_csv(dplyr::bind_rows(parity_basic_metadata, parity_org_metadata),
                                   file.path(config$paths$reports, "parity_metadata.csv")) |>
    tar_file()

  # fails the build on any mismatch; runs after both reports are written
  parity_summary = parity_gate(
      dplyr::bind_rows(parity_basic_values, parity_org_values),
      dplyr::bind_rows(parity_basic_metadata, parity_org_metadata)
    ) |>
    tar_target()

  #################
  # FINAL RELEASE #
  #################
  # one file per year; one per month for a partial year
  basic_feather = label_extract(basic_year, registry, value_labels, "basic", data_label("basic", release_file)) |>
    write_extract("basic", config$paths$output, config) |>
    tar_target(pattern = map(basic_year), format = "file")

  org_feather = label_extract(org_year, registry, value_labels, "org", data_label("org", release_file)) |>
    write_extract("org", config$paths$output, config) |>
    tar_target(pattern = map(org_year), format = "file")
})
