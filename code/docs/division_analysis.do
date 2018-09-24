sum year
keep if year == r(max)
gegen tag = tag(statefips)
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

forvalues i = 1 / 9 {
  local divisionname`i': label division `i'
}

maptile division, geo(state) geoid(statefips) ///
cutpoints(division) ///
fcolor(""`color1'" "`color2'" "`color3'" "`color4'" "`color5'" "`color6'" "`color7'" "`color8'" "`color9'"") ///
twopt( ///
  graphregion(color("252 252 252")) ///
  plotregion(color("252 252 252")) ///
  legend( ///
    size(small) ///
    order(2 3 4 5 6 7 8 9) ///
    lab(2 "`divisionname1'") ///
    lab(3 "`divisionname2'") ///
    lab(4 "`divisionname3'") ///
    lab(5 "`divisionname4'") ///
    lab(6 "`divisionname5'") ///
    lab(7 "`divisionname6'") ///
    lab(8 "`divisionname7'") ///
    lab(9 "`divisionname8'") ///
    lab(10 "`divisionname9'") ///
  ) ///
)

graph export ${variableimages}division_titleimage.svg, replace
