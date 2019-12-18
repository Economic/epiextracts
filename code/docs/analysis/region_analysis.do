
sum year
keep if year == r(max)
gegen tag = tag(statefips)
keep if tag == 1
keep statefips region

local color1 123 50 148
local color2 194 165 207
local color3 166 219 160
local color4 0 136 55

forvalues i = 1 / 4 {
  local regionname`i': label region `i'
}

maptile region, geo(state) geoid(statefips) ///
  fcolor(""`color1'" "`color2'" "`color3'" "`color4'"") ///
  twopt( ///
    graphregion(color(white)) plotregion(color(white)) ///
    legend( ///
      order(2 3 4 5) ///
      lab(2 "`regionname1'") ///
      lab(3 "`regionname2'") ///
      lab(4 "`regionname3'") ///
      lab(5 "`regionname4'") ///
    ) ///
  )

graph export ${variableimages}region_titleimage.svg, replace
