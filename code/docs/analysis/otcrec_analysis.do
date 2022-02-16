keep if otcrec ~= .
keep if age >= 16 & age <= 64

gcollapse (mean) otcrec_ = otcrec [pw=orgwgt], by(year female) fast

* make wide and graph
reshape wide otcrec_, i(year) j(female)
foreach var of varlist otcrec_* {
	replace `var' = `var' * 100
	sum `var' if year == 2015
	local `var'yvalue = r(mean)
	local `var'xvalue = 2015
}
local otcrec_0yvalue = `otcrec_0yvalue' + 1.5
local otcrec_1yvalue = `otcrec_1yvalue' - 2

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line otcrec_0 otcrec_1 year, lcolor("`color4'" "`color2'") ///
legend(off) ///
xlabel(1995(5)2020) ///
ylabel(0(5)30 30 "30%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Share of hourly earners receiving overtime/tips/commissions", size(medium)) ///
text(`otcrec_0yvalue' `otcrec_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`otcrec_1yvalue' `otcrec_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}otcrec_titleimage.svg, replace

/***
The analysis above uses hourly wage earners, ages 16-64,from the CPS ORG for 1994-2021.
***/
