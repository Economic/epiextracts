keep if age >= 25 & age <= 54
keep if year >= 1976

gcollapse (mean) nilf_ = nilf [pw=basicwgt], by(year female) fast
foreach var of varlist nilf_* {
	replace `var' = `var' * 100
}
reshape wide nilf_, i(year) j(female)

* grab useful values for figure values
foreach var of varlist nilf_* {
	sum `var' if year == 2009
	local `var'yvalue = r(mean)
	local `var'xvalue = 2009
}
local nilf_0yvalue = `nilf_0yvalue' - 3
local nilf_1yvalue = `nilf_1yvalue' + 3

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line nilf_0 nilf_1 year, ///
legend(off) ///
xlabel(1975(5)2020) ///
ylabel(0(10)40 50 "50%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Share of prime-age population not in the labor force, by gender", size(medium)) ///
text(`nilf_0yvalue' `nilf_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`nilf_1yvalue' `nilf_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}nilf_titleimage.svg, replace
