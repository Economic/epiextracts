keep if age >= 16 & age != .
recode wage (0 = .)
recode wageotc (0 = .)

gen wgt = .
replace wgt = basicwgt if year <= 1978
replace wgt = orgwgt if year >= 1979

gcollapse (mean) wage_noadj wage [pw=wgt], by(year) fast
* inflation-adjust wages
preserve
sysuse cpi_annual, clear
keep year cpiurs
keep if year > = 1973
tempfile cpiurs
save `cpiurs'
restore
merge m:1 year using `cpiurs', keep(3) nogenerate
sum cpiurs if year == 2021
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
xlabel(1975(5)2020) ///
ylabel(18(2)28 30 "$30", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Mean real wages (in 2021`dollar')", size(medium)) ///
text(`wageyvalue' `wagexvalue' "wage (adjusted)", color("`color2'") placement(c)) ///
text(`wage_noadjyvalue' `wage_noadjxvalue' "wage_noadj (unadjusted)", color("`color4'") placement(c))
graph export ${variableimages}wage_noadj_titleimage.svg, replace

/***
The analysis above uses the CPS ORG for 1979-2021 and the CPS May for 1973-1978.
***/
