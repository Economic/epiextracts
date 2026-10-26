#' suppdata/state_geocodes.csv: state -> statecensus/division/region lookup.
#' Only the codes are needed; the names become value labels (value_labels.csv).
build_state_geocodes <- function(geocodes_file) {
  readr::read_csv(geocodes_file, show_col_types = FALSE) |>
    dplyr::select(statefips, statecensus, division, region)
}

# --- statecensus/division/region (generate_statefips.do merge) -----------
recode_statecensus <- function(statefips, state_geocodes) {
  state_geocodes$statecensus[match(statefips, state_geocodes$statefips)]
}
