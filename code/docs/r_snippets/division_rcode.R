#' suppdata/state_geocodes.csv: state -> statecensus/division/region lookup.
#' Only the codes are needed (not statename/stateabb/divisionname/regionname
#' labels), since this feeds a numeric join, not a display/report.
build_state_geocodes <- function() {
  readr::read_csv("/projects/jkandra/epiextracts/suppdata/state_geocodes.csv", show_col_types = FALSE) |>
    dplyr::select(statefips, statecensus, division, region)
}
