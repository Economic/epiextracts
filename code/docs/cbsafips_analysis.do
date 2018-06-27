webdoc init ${variablelongdesc}cbsafips_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

sum year
local maxyear = r(max)
keep if year == `maxyear'

keep if age >= 16 & age <= 64
rename cbsafips cbsa2013

collapse (count) n=year, by(cbsa2013)

local color1 123 50 148
local color2 194 165 207
local color3 166 219 160
local color4 0 136 55

#delimit ;
maptile n,
  geo(cbsa2013) fcolor(BrBG) ndfcolor(gs12)
  twopt(
    graphregion(color("252 252 252"))
    title("CBSA identified sample sizes of individuals ages 16-64 in `maxyear'", size(medium))
  )
;
#delimit cr;

graph export ${variableimages}cbsafips_titleimage.svg, replace
