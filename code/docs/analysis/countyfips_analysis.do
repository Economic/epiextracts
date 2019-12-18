sum year
local maxyear = r(max)
keep if year == `maxyear'

keep if age >= 16 & age <= 64

tostring statefips, gen(state) format(%02.0f)
tostring countyfips, gen(county) format(%03.0f)
replace county = state + county
destring county, replace
gcollapse (count) n=year, by(county)

local color1 123 50 148
local color2 194 165 207
local color3 166 219 160
local color4 0 136 55

#delimit ;
maptile n,
  geo(county2014) fcolor(BrBG) ndfcolor(white)
  twopt(
    graphregion(color(white))
    title("County identified sample sizes of individuals ages 16-64 in `maxyear'", size(medium))
  )
;
#delimit cr;

graph export ${variableimages}countyfips_titleimage.svg, replace
