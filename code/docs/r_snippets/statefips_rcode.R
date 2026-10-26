# --- statefips (generate_statefips.do), 1994+ ------------------------------
# statecensus/division/region are looked up from it in R/geography.R.
recode_statefips <- function(gestfips) as.numeric(gestfips)
