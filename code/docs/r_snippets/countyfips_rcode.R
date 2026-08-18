# --- countyfips (generate_countyfips.do), Basic Monthly only --------------
# geco (1995m9-2004m4) -> gtco (2004m5+); direct passthrough, heavily
# suppressed by Census design (~60% missing in some years) -- not a gap to fix.
recode_countyfips <- function(year, month, geco, gtco) {
  dplyr::if_else(year < 2004 | (year == 2004 & month <= 4), as.numeric(geco), as.numeric(gtco))
}
