source("./packages.R")

## CONFIGURATION
years            <- 2000:2024
raw_source_dir   <- "/data/cps/basic/census/stata"
reference_dir    <- "/projects/jkandra/epiextracts/extracts"
pilot_output_dir <- "output"
reweight_years   <- 2000:2002 # Census-2000-based reweight window for cmpwgt/orgwgt

demographic_variables <- c("educ", "wbho", "citistat", "married", "statefips", "union", "pubsec", "mind16")
geography_variables   <- c("statecensus", "division", "region", "countyfips", "cbsafips", "cbsasize", "metstat")
basic_variables <- c("age", "female", "emp", "basicwgt", demographic_variables, geography_variables)
org_variables   <- c("age", "female", "emp", "basicwgt", "orgwgt", "hoursu1i", "weekpay", "wage", demographic_variables, geography_variables)

lapply(list.files("./R", full.names = TRUE), source)

tar_option_set(format = "rds")

tar_assign({
  ###############
  # INPUT FILES #
  ###############
  basic_years = years |>
    tar_target()

  reference_dta = year_to_reference_path(basic_years, reference_dir, sample = "basic") |>
    tar_target(pattern = map(basic_years), format = "file")

  reference_org_dta = year_to_reference_path(basic_years, reference_dir, sample = "org") |>
    tar_target(pattern = map(basic_years), format = "file")

  #########################
  # INTERMEDIATE OUTPUTS  #
  #########################
  raw_year = read_raw_year(basic_years, raw_source_dir) |>
    tar_target(pattern = map(basic_years))

  state_geocodes = build_state_geocodes() |>
    tar_target() # shared, non-branched -- 51-row state->division/region/statecensus lookup

  recoded_year = recode_year(raw_year, reweight_years, state_geocodes) |>
    tar_target(pattern = map(raw_year))

  wage_bounds = build_wage_bounds() |>
    tar_target() # shared, non-branched -- built once from realtalk, consumed by every year

  # tc_fix's 2023 reference constants need 2023's own ORG-filtered data
  # regardless of which year is currently being processed elsewhere in the
  # DAG; recomputed directly here (cheap, one year) rather than fragile
  # indexing into a specific branch of the dynamic raw_year/recoded_year targets.
  org_2023_pretopcode = filter_org_universe(recode_year(read_raw_year(2023, raw_source_dir), reweight_years, state_geocodes)) |>
    tar_target()

  tc_constants = compute_tc_constants(org_2023_pretopcode) |>
    tar_target()

  recoded_org_year = recode_org_year(recoded_year, wage_bounds, tc_constants) |>
    tar_target(pattern = map(recoded_year))

  parity_year = compare_year(recoded_year, reference_dta, basic_variables, sample = "basic") |>
    tar_target(pattern = map(recoded_year, reference_dta))

  parity_org_year = compare_year(recoded_org_year, reference_org_dta, org_variables, sample = "org") |>
    tar_target(pattern = map(recoded_org_year, reference_org_dta))

  #################
  # FINAL RELEASE #
  #################
  pilot_feather = create_feather(
      recoded_year,
      file.path(pilot_output_dir, paste0("pilot_cpsbasic_", unique(recoded_year$year), ".feather"))
    ) |>
    tar_target(pattern = map(recoded_year), format = "file")

  pilot_org_feather = create_feather(
      recoded_org_year,
      file.path(pilot_output_dir, paste0("pilot_cpsorg_", unique(recoded_org_year$year), ".feather"))
    ) |>
    tar_target(pattern = map(recoded_org_year), format = "file")

  parity_report = dplyr::bind_rows(parity_year, parity_org_year) |>
    tar_target()

  parity_report_csv = create_csv(parity_report, "reports/parity_report.csv") |>
    tar_file()
})
