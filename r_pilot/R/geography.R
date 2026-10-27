# Geography (code/docs/variables_groups.csv group "geography").
# statecensus/division/region come from suppdata/state_geocodes.csv, looked
# up by statefips; countyfips/cbsafips/cbsasize/metstat are recodes of raw
# Census fields (no external crosswalk).

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
recode_division <- function(statefips, state_geocodes) {
  state_geocodes$division[match(statefips, state_geocodes$statefips)]
}
recode_region <- function(statefips, state_geocodes) {
  state_geocodes$region[match(statefips, state_geocodes$statefips)]
}

# --- countyfips (generate_countyfips.do), Basic Monthly only --------------
# geco (1995m9-2004m4) -> gtco (2004m5+), missing before 1995m9; direct
# passthrough, heavily suppressed by Census design (~60% missing in some
# years) -- not a gap to fix.
recode_countyfips <- function(year, month, geco, gtco) {
  ym <- year * 12 + month
  dplyr::case_when(
    ym < 1995 * 12 + 9 ~ NA_real_,
    ym <= 2004 * 12 + 4 ~ as.numeric(geco),
    TRUE ~ as.numeric(gtco)
  )
}

# --- cbsafips (generate_cbsafips.do), Basic Monthly only ------------------
# Unpopulated before 2004m5 (gtcbsa doesn't exist as a raw column until then).
recode_cbsafips <- function(year, month, gtcbsa) {
  dplyr::if_else(year > 2004 | (year == 2004 & month >= 5), as.numeric(gtcbsa), NA_real_)
}

# --- cbsasize (generate_cbsasize.do), Basic Monthly only ------------------
# Same 2004m5 boundary as cbsafips.
recode_cbsasize <- function(year, month, gtcbsasz) {
  dplyr::if_else(year > 2004 | (year == 2004 & month >= 5), as.numeric(gtcbsasz), NA_real_)
}

# --- metstat (generate_metstat.do) ----------------------------------------
# gemetsta (...-2004m4) -> gtmetsta (2004m5+), both recoded 1->1 (metro),
# 2->0 (nonmetro). No metro data in 1995m6-1995m8 (Census suppression).
recode_metstat <- function(year, month, gemetsta, gtmetsta) {
  ym <- year * 12 + month
  src <- dplyr::if_else(ym <= 2004 * 12 + 4, as.numeric(gemetsta), as.numeric(gtmetsta))
  src <- dplyr::if_else(ym >= 1995 * 12 + 6 & ym <= 1995 * 12 + 8, NA_real_, src)
  dplyr::case_when(
    src == 1 ~ 1,
    src == 2 ~ 0,
    TRUE     ~ NA_real_
  )
}
