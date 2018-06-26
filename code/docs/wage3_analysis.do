webdoc init ${variablelongdesc}wage3_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

keep if wage3 > 0 & wage3 ~= .

collapse (p50) wage3_ = wage3 [pw=orgwgt], by(year female) fast
* inflation-adjust wages
preserve
import delimited ${suppdata}cpiurs_allitems.csv, clear
keep year avg
rename avg cpiurs
keep if cpiurs ~= .
tempfile cpiurs
save `cpiurs'
restore
merge m:1 year using `cpiurs', keep(3) nogenerate
sum cpiurs if year == 2017
local basevalue = r(mean)
replace wage3 = wage3 * `basevalue' / cpiurs

* make wide and graph
reshape wide wage3_, i(year) j(female)
sum year
local maxyear = r(max)
foreach var of varlist wage3_* {
	sum `var' if year == `maxyear'
	local `var'yvalue = r(mean)
	local `var'xvalue = `maxyear' + 0.5
}

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
graphregion(color("252 252 252") margin(r=15)) plotregion(color("252 252 252")) ///
title("Median wages by gender, 1979-2017 (in 2017$)", size(medium)) ///
text(`wage3_0yvalue' `wage3_0xvalue' "Male", color("`color4'") placement(e)) ///
text(`wage3_1yvalue' `wage3_1xvalue' "Female", color("`color2'") placement(e))
graph export ${variableimages}wage3_titleimage.svg, replace

/***
some detailed notes for wage3
***/
