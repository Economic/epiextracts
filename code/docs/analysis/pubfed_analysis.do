keep if pubfed ~= .
keep if age >= 16 & age <= 64
keep if emp == 1

gcollapse (mean) pubfed_ = pubfed [pw=basicwgt], by(year female) fast

* make wide and graph
reshape wide pubfed_, i(year) j(female)
foreach var of varlist pubfed_* {
	replace `var' = `var' * 100
	sum `var' if year == 2014
	local `var'yvalue = r(mean)
	local `var'xvalue = 2014
}
local pubfed_0yvalue = `pubfed_0yvalue' + 1
local pubfed_1yvalue = `pubfed_1yvalue' - 1

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line pubfed_0 pubfed_1 year if year <= 1975, lcolor("`color4'" "`color2'") || ///
line pubfed_0 pubfed_1 year if 1976 <= year & year <= 1988, lcolor("`color4'" "`color2'") || ///
line pubfed_0 pubfed_1 year if 1989 <= year & year <= 1993, lcolor("`color4'" "`color2'") || ///
line pubfed_0 pubfed_1 year if 1994 <= year, lcolor("`color4'" "`color2'") ///
legend(off) ///
xlabel(1990(5)2020) ///
ylabel(0(5)20 25 "25%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Federal government share of workforce, ages 16-64, by gender", size(medium)) ///
text(`pubfed_0yvalue' `pubfed_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`pubfed_1yvalue' `pubfed_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}pubfed_titleimage.svg, replace

/***
The analysis above uses employed workers in the CPS Basic for 1989-2021.
***/
