keep if age >= 16 & age <= 64
recode wage (0 = .)
recode wageotc (0 = .)

gen wgt = .
replace wgt = basicwgt if year <= 1978
replace wgt = orgwgt if year >= 1979

gcollapse (mean) wage_noadj wage [pw=wgt], by(year) fast
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
replace wage_noadj = wage_noadj * `basevalue' / cpiurs

* make graph
foreach var of varlist wage* {
	sum `var' if year == 2008
	local `var'yvalue = r(mean)
	local `var'xvalue = 2008
}
local wageyvalue = `wageyvalue' + 1.0
local wage_noadjyvalue = `wage_noadjyvalue' - 1.0

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

local dollar=char(36)

line wage_noadj wage year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(16(2)22 24 "$24", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Mean real wages for ages 16-64, 1973-2017 (in 2018`dollar')", size(medium)) ///
text(`wageyvalue' `wagexvalue' "wage (adjusted)", color("`color2'") placement(c)) ///
text(`wage_noadjyvalue' `wage_noadjxvalue' "wage_noadj (unadjusted)", color("`color4'") placement(c))
graph export ${variableimages}wage_noadj_titleimage.svg, replace

/***
The analysis above uses the CPS ORG for 1979-2017 and the CPS May for 1973-1978.
***/
