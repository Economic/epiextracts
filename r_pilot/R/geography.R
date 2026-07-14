# Geography category (code/docs/variables_groups.csv group "geography").
# statefips (recode_statefips in R/demographics.R) already exists; this file
# adds statecensus/division/region (via the state_geocodes.csv crosswalk,
# joined on statefips) plus countyfips/cbsafips/cbsasize/metstat (direct
# passthroughs/recodes of raw Census fields, no external crosswalk needed --
# confirmed no CBSA/MSA delineation file exists anywhere in this project).

#' suppdata/state_geocodes.csv: state -> statecensus/division/region lookup.
#' Only the codes are needed (not statename/stateabb/divisionname/regionname
#' labels), since this feeds a numeric join, not a display/report.
build_state_geocodes <- function() {
  readr::read_csv("/projects/jkandra/epiextracts/suppdata/state_geocodes.csv", show_col_types = FALSE) |>
    dplyr::select(statefips, statecensus, division, region)
}

# --- countyfips (generate_countyfips.do), Basic Monthly only --------------
# geco (1995m9-2004m4) -> gtco (2004m5+); direct passthrough, heavily
# suppressed by Census design (~60% missing in some years) -- not a gap to fix.
recode_countyfips <- function(year, month, geco, gtco) {
  dplyr::if_else(year < 2004 | (year == 2004 & month <= 4), as.numeric(geco), as.numeric(gtco))
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
# 2->0 (nonmetro). The 1994m1-1995m5/1995m9-2004m4 Stata sub-split collapses
# to a single 2004m5 boundary here since both sub-eras share the same raw
# column; the 1995m6-1995m8 Census-side suppression gap predates our 2000-2024
# scope entirely.
recode_metstat <- function(year, month, gemetsta, gtmetsta) {
  src <- dplyr::if_else(year < 2004 | (year == 2004 & month <= 4), as.numeric(gemetsta), as.numeric(gtmetsta))
  dplyr::case_when(
    src == 1 ~ 1,
    src == 2 ~ 0,
    TRUE     ~ NA_real_
  )
}
