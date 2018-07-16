webdoc init ${variablelongdesc}wage3_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

keep if wage3 > 0 & wage3 ~= .
keep if age >= 16 & age <= 64

gen wgt = .
replace wgt = basicwgt if year <= 1978
replace wgt = orgwgt if year >= 1979

collapse (p50) wage3_ = wage3 [pw=wgt], by(year female) fast
* inflation-adjust wages
preserve
import delimited ${suppdata}cpiurs_allitems.csv, clear
keep year avg
rename avg cpiurs
keep if cpiurs ~= .
* for 1973-1977 use EPI's spliced CPI-X1 series
* manually add these
forvalues i = 1973(1)1977 {
	moreobs 1
	replace year = `i' if year == .
}
replace cpiurs = 73.0 if year == 1973
replace cpiurs = 80.3 if year == 1974
replace cpiurs = 86.9 if year == 1975
replace cpiurs = 91.9 if year == 1976
replace cpiurs = 97.7 if year == 1977
tempfile cpiurs
save `cpiurs'
restore
merge m:1 year using `cpiurs', keep(3) nogenerate
sum cpiurs if year == 2017
local basevalue = r(mean)
replace wage3 = wage3 * `basevalue' / cpiurs

* make wide and graph
reshape wide wage3_, i(year) j(female)
foreach var of varlist wage3_* {
	sum `var' if year == 2009
	local `var'yvalue = r(mean)
	local `var'xvalue = 2009
}
local wage3_0yvalue = `wage3_0yvalue' - 1.2
local wage3_1yvalue = `wage3_1yvalue' - 1

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line wage3_0 wage3_1 year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(12(2)18 20 "$20", angle(0)) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Median real wages for ages 16-64, by gender, 1973-2017 (in 2017$)", size(medium)) ///
text(`wage3_0yvalue' `wage3_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`wage3_1yvalue' `wage3_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}wage3_titleimage.svg, replace

/***
The analysis above uses the CPS ORG for 1979-2017 and the CPS May for 1973-1978.
***/
