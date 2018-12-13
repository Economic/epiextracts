keep if unemp == 1 | emp == 1

* keep only 1976+ for annual data to avoid seasonality issues
keep if year >= 1976

gen byte black = unemp if wbho == 2
gen byte nonblack = unemp if wbho ~= 2 & wbho ~= .

gcollapse (mean) black nonblack [pw=basicwgt], by(year) fast
replace black = black * 100
replace nonblack = nonblack * 100

foreach var of varlist black nonblack {
	sum `var' if year == 1996
	local `var'yvalue = r(mean)
	local `var'xvalue = 1996
}
local blackyvalue = `blackyvalue' + 2
local nonblackyvalue = `nonblackyvalue' - 2


local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line black nonblack year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(0(5)15 20 "20%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Unemployment rates by race, 1976-2017", size(medium)) ///
text(`blackyvalue' `blackxvalue' "Black", color("`color1'") placement(c)) ///
text(`nonblackyvalue' `nonblackxvalue' "Non-black", color("`color2'") placement(c))
graph export ${variableimages}unemp_titleimage.svg, replace
