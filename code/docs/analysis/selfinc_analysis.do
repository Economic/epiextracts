keep if selfinc ~= .
keep if age >= 16 & age <= 64
keep if emp == 1

gcollapse (mean) selfinc_ = selfinc [pw=basicwgt], by(year female) fast

* make wide and graph
reshape wide selfinc_, i(year) j(female)
foreach var of varlist selfinc_* {
	replace `var' = `var' * 100
	sum `var' if year == 2014
	local `var'yvalue = r(mean)
	local `var'xvalue = 2014
}
local selfinc_0yvalue = `selfinc_0yvalue' + 1
local selfinc_1yvalue = `selfinc_1yvalue' - 1

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line selfinc_0 selfinc_1 year if year <= 1975, lcolor("`color4'" "`color2'") || ///
line selfinc_0 selfinc_1 year if 1976 <= year & year <= 1988, lcolor("`color4'" "`color2'") || ///
line selfinc_0 selfinc_1 year if 1989 <= year & year <= 1993, lcolor("`color4'" "`color2'") || ///
line selfinc_0 selfinc_1 year if 1994 <= year, lcolor("`color4'" "`color2'") ///
legend(off) ///
xlabel(1990(5)2020) ///
ylabel(0(5)20 25 "25%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Self-employed share of workforce, ages 16-64, by gender", size(medium)) ///
text(`selfinc_0yvalue' `selfinc_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`selfinc_1yvalue' `selfinc_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}selfinc_titleimage.svg, replace

/***
The analysis above uses employed workers in the CPS Basic for 1989-2024.
***/
