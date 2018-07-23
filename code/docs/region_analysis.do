webdoc init ${variablelongdesc}region_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

sum year
keep if year == r(max)
gegen tag = tag(statefips)
keep if tag == 1
keep statefips region

local color1 123 50 148
local color2 194 165 207
local color3 166 219 160
local color4 0 136 55

maptile region, geo(state) geoid(statefips) fcolor(""`color1'" "`color2'" "`color3'" "`color4'"") twopt(graphregion(color("252 252 252")) plotregion(color("252 252 252")) legend(order(2 3 4 5) lab(2 "`: label (region) 1'") lab(3 "`: label (region) 2'") lab(4 "`: label (region) 3'") lab(5 "`: label (region) 4'")))

graph export ${variableimages}region_titleimage.svg, replace
