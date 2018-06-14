webdoc init ${variablelongdesc}division_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

sum year
keep if year == r(max)
egen tag = tag(statefips)
keep if tag == 1
keep statefips division

local color1 118 42 131
local color2 153 112 171
local color3 194 165 207
local color4 231 212 232
local color5 247 247 247
local color6 217 240 211
local color7 166 219 160
local color8 90 174 97
local color9 27 120 55

maptile division, geo(state) geoid(statefips) cutpoints(division) fcolor(""`color1'" "`color2'" "`color3'" "`color4'" "`color5'" "`color6'" "`color7'" "`color8'" "`color9'"") twopt(graphregion(color("252 252 252")) plotregion(color("252 252 252")) legend(size(small) order(2 3 4 5 6 7 8 9) lab(2 "`: label (division) 1'") lab(3 "`: label (division) 2'") lab(4 "`: label (division) 3'") lab(5 "`: label (division) 4'") lab(6 "`: label (division) 5'") lab(7 "`: label (division) 6'") lab(8 "`: label (division) 7'") lab(9 "`: label (division) 8'") lab(10 "`: label (division) 9'")))

graph export ${variableimages}division_titleimage.svg, replace
