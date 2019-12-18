keep if wage > 0 & wage ~= .
keep if age >= 16 & age != .

gen wgt = .
replace wgt = basicwgt if year <= 1978
replace wgt = orgwgt if year >= 1979

gcollapse (p50) wage_ = wage [pw=wgt], by(year female) fast
* inflation-adjust wages
preserve
import delimited using ${suppdata}cpiurs_extended.csv, clear varnames(1)
rename cpiurs_extended cpiurs
keep year cpiurs
keep if year > = 1973
tempfile cpiurs
save `cpiurs'
restore
merge m:1 year using `cpiurs', keep(3) nogenerate
sum cpiurs if year == 2018
local basevalue = r(mean)
replace wage = wage * `basevalue' / cpiurs

* make wide and graph
reshape wide wage_, i(year) j(female)
foreach var of varlist wage_* {
	sum `var' if year == 2009
	local `var'yvalue = r(mean)
	local `var'xvalue = 2009
}
local wage_0yvalue = `wage_0yvalue' - 1.2
local wage_1yvalue = `wage_1yvalue' - 1

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

local dollar=char(36)

line wage_0 wage_1 year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(12(2)22 22 "$22", angle(0)) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Median real wages by gender, 1973-2018 (in 2018`dollar')", size(medium)) ///
text(`wage_0yvalue' `wage_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`wage_1yvalue' `wage_1xvalue' "Female", color("`color2'") placement(c))

graph export ${variableimages}wage_titleimage.svg, replace

/***
The analysis above uses the CPS ORG for 1979-2018 and the CPS May for 1973-1978.
***/
