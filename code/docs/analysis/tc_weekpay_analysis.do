keep if tc_weekpay ~= .
keep if age >= 16 & age <= 64

gen wgt = .
replace wgt = basicwgt if year <= 1978
replace wgt = orgwgt if year >= 1979

gcollapse (mean) tc_ = tc_weekpay [pw=wgt], by(year female) fast

* make wide and graph
reshape wide tc_, i(year) j(female)
foreach var of varlist tc_* {
	replace `var' = `var' * 100
	sum `var' if year == 2013
	local `var'yvalue = r(mean)
	local `var'xvalue = 2013
}
local tc_0yvalue = `tc_0yvalue' + 0.7
local tc_1yvalue = `tc_1yvalue' - 0.7

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line tc_0 tc_1 year, lcolor("`color4'" "`color2'") ///
legend(off) ///
xlabel(1975(5)2020) ///
ylabel(0(2)10 10 "10%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Share of earners with top-coded weekly pay, ages 16-64", size(medium)) ///
text(`tc_0yvalue' `tc_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`tc_1yvalue' `tc_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}tc_weekpay_titleimage.svg, replace

/***
The analysis above uses observations with positive weekly earnings workers in the CPS ORG for 1979-2023 and the CPS May for 1973-1978.
***/
