gen byte lfpr = lfstat == 1 | lfstat == 2 if lfstat ~= .
keep if age >= 25 & age <= 54
keep if year >= 1976

gcollapse (mean) lfpr_ = lfpr [pw=basicwgt], by(year female) fast
foreach var of varlist lfpr_* {
	replace `var' = `var' * 100
}
reshape wide lfpr_, i(year) j(female)

* grab useful values for figure values
foreach var of varlist lfpr_* {
	sum `var' if year == 2009
	local `var'yvalue = r(mean)
	local `var'xvalue = 2009
}
local lfpr_0yvalue = `lfpr_0yvalue' + 3
local lfpr_1yvalue = `lfpr_1yvalue' - 3

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line lfpr_0 lfpr_1 year, ///
legend(off) ///
xlabel(1975(5)2020) ///
ylabel(50(10)90 100 "100%", angle(0)) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Prime-age labor force participation rates, by gender", size(medium)) ///
text(`lfpr_0yvalue' `lfpr_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`lfpr_1yvalue' `lfpr_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}lfstat_titleimage.svg, replace
