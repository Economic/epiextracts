keep if paidhre ~= .
keep if age >= 16 & age <= 64

gen wgt = .
replace wgt = basicwgt if year <= 1978
replace wgt = orgwgt if year >= 1979

gcollapse (mean) paidhre_ = paidhre [pw=wgt], by(year female) fast

* make wide and graph
reshape wide paidhre_, i(year) j(female)
foreach var of varlist paidhre_* {
	replace `var' = `var' * 100
	sum `var' if year == 2013
	local `var'yvalue = r(mean)
	local `var'xvalue = 2013
}
local paidhre_0yvalue = `paidhre_0yvalue' - 5
local paidhre_1yvalue = `paidhre_1yvalue' + 5

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line paidhre_0 paidhre_1 year if year <= 1978, lcolor("`color4'" "`color2'") || ///
line paidhre_0 paidhre_1 year if 1979 <= year & year <= 1993, lcolor("`color4'" "`color2'") || ///
line paidhre_0 paidhre_1 year if 1994 <= year, lcolor("`color4'" "`color2'") ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(0(20)80 100 "100%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Share of workforce paid by the hour, ages 16-64, by gender", size(medium)) ///
text(`paidhre_0yvalue' `paidhre_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`paidhre_1yvalue' `paidhre_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}paidhre_titleimage.svg, replace

/***
The analysis above uses the CPS ORG for 1979-2019 and the CPS May for 1973-1978.
***/
