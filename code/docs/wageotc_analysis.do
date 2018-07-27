webdoc init ${variablelongdesc}wageotc_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

keep if age >= 16 & age <= 64
recode wage (0 = .)
recode wageotc (0 = .)

gen wgt = .
replace wgt = basicwgt if year <= 1978
replace wgt = orgwgt if year >= 1979

gcollapse (p50) wage wageotc [pw=wgt], by(year) fast
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
replace wage = wage * `basevalue' / cpiurs
replace wageotc = wageotc * `basevalue' / cpiurs

* make graph
foreach var of varlist wage* {
	sum `var' if year == 2008
	local `var'yvalue = r(mean)
	local `var'xvalue = 2008
}
local wageyvalue = `wageyvalue' - 0.8
local wageotcyvalue = `wageotcyvalue' + 1.0

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line wage wageotc year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(12(2)18 20 "$20", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Median real wages for ages 16-64, 1973-2017 (in 2017$)", size(medium)) ///
text(`wageyvalue' `wagexvalue' "wage", color("`color4'") placement(c)) ///
text(`wageotcyvalue' `wageotcxvalue' "wageotc", color("`color2'") placement(c))
graph export ${variableimages}wageotc_titleimage.svg, replace

/***
The analysis above uses the CPS ORG for 1979-2017 and the CPS May for 1973-1978.
***/
