#' suppdata/state_geocodes.csv: state -> statecensus/division/region lookup.
#' Only the codes are needed; the names become value labels (value_labels.csv).
build_state_geocodes <- function(geocodes_file) {
  readr::read_csv(geocodes_file, show_col_types = FALSE) |>
    dplyr::select(statefips, statecensus, division, region)
}

recode_division <- function(statefips, state_geocodes) {
  state_geocodes$division[match(statefips, state_geocodes$statefips)]
}
