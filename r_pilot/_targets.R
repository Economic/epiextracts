source("./packages.R")

## CONFIGURATION
years            <- 2000:2024
raw_source_dir   <- "/data/cps/basic/census/stata"
reference_dir    <- "/projects/jkandra/epiextracts/extracts"
pilot_output_dir <- "output"
reweight_years   <- 2000:2002 # Census-2000-based reweight window for cmpwgt

lapply(list.files("./R", full.names = TRUE), source)

tar_option_set(format = "rds")

tar_assign({
  ###############
  # INPUT FILES #
  ###############
  basic_years = years |>
    tar_target()

  reference_dta = year_to_reference_path(basic_years, reference_dir) |>
    tar_target(pattern = map(basic_years), format = "file")

  #########################
  # INTERMEDIATE OUTPUTS  #
  #########################
  raw_year = read_raw_year(basic_years, raw_source_dir) |>
    tar_target(pattern = map(basic_years))

  recoded_year = recode_year(raw_year, reweight_years) |>
    tar_target(pattern = map(raw_year))

  parity_year = compare_year(recoded_year, reference_dta) |>
    tar_target(pattern = map(recoded_year, reference_dta))

  #################
  # FINAL RELEASE #
  #################
  pilot_feather = create_feather(
    recoded_year,
    file.path(pilot_output_dir, paste0("pilot_cpsbasic_", unique(recoded_year$year), ".feather"))
  ) |>
    tar_target(pattern = map(recoded_year), format = "file")

  parity_report = dplyr::bind_rows(parity_year) |>
    tar_target()

  parity_report_csv = create_csv(parity_report, "reports/parity_report.csv") |>
    tar_file()
})
