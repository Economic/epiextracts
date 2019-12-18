sum year
local maxyear = r(max)
keep if year == `maxyear'

keep if age >= 16 & age <= 64
rename cbsafips cbsa2013

gcollapse (count) n=year, by(cbsa2013)

local color1 123 50 148
local color2 194 165 207
local color3 166 219 160
local color4 0 136 55

#delimit ;
maptile n,
  geo(cbsa2013) fcolor(BrBG) ndfcolor(gs12)
  twopt(
    graphregion(color(white))
    title("CBSA identified sample sizes of individuals ages 16-64 in `maxyear'", size(medium))
  )
;
#delimit cr;

graph export ${variableimages}cbsafips_titleimage.svg, replace
