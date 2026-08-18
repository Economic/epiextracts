# --- statefips (generate_statefips.do), 1994+ ------------------------------
# Stata's script also merges in state_geocodes.csv, but only for value
# labels/region -- not needed here since we expose the bare FIPS code
# (a future dedicated Geography phase can add region/division properly).
recode_statefips <- function(gestfips) as.numeric(gestfips)
