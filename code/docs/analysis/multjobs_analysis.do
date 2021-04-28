keep if multjobs ~= .
keep if age >= 16 & age ~= .

gcollapse (mean) multjobs_ = multjobs [pw=basicwgt], by(year female) fast

* make wide and graph
reshape wide multjobs_, i(year) j(female)
foreach var of varlist multjobs_* {
	replace `var' = `var' * 100
	sum `var' if year == 2014
	local `var'yvalue = r(mean)
	local `var'xvalue = 2014
}
local multjobs_0yvalue = `multjobs_0yvalue' - 0.7
local multjobs_1yvalue = `multjobs_1yvalue' + 0.7

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line multjobs_0 multjobs_1 year if 1994 <= year, lcolor("`color4'" "`color2'") ///
legend(off) ///
xlabel(1995(5)2020) ///
ylabel(0(2)8 10 "12%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Share of workforce with multiple jobs, by gender", size(medium)) ///
text(`multjobs_0yvalue' `multjobs_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`multjobs_1yvalue' `multjobs_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}multjobs_titleimage.svg, replace
