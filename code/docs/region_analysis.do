webdoc init ${variablelongdesc}region_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

sum year
keep if year == r(max)
egen tag = tag(statefips)
keep if tag == 1
keep statefips region

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

maptile region, geo(state) geoid(statefips) fcolor(""`color1'" "`color2'" "`color3'" "`color4'"") twopt(graphregion(color("252 252 252")) plotregion(color("252 252 252")) legend(order(2 3 4 5) lab(2 "`: label (region) 1'") lab(3 "`: label (region) 2'") lab(4 "`: label (region) 3'") lab(5 "`: label (region) 4'")))
graph export ${variableimages}region_titleimage.svg, replace
