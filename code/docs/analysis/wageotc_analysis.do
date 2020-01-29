keep if age >= 16 & age != .
recode wage (0 = .)
recode wageotc (0 = .)

gen wgt = .
replace wgt = basicwgt if year <= 1978
replace wgt = orgwgt if year >= 1979

gcollapse (p50) wage wageotc [pw=wgt], by(year) fast
* inflation-adjust wages
preserve
sysuse cpi_annual
keep year cpiurs
keep if year > = 1973
tempfile cpiurs
save `cpiurs'
restore
merge m:1 year using `cpiurs', keep(3) nogenerate
sum cpiurs if year == 2019
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

local dollar=char(36)

line wage wageotc year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(12(2)18 20 "$20", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Median real wages (in 2019`dollar')", size(medium)) ///
text(`wageyvalue' `wagexvalue' "wage", color("`color4'") placement(c)) ///
text(`wageotcyvalue' `wageotcxvalue' "wageotc", color("`color2'") placement(c))
graph export ${variableimages}wageotc_titleimage.svg, replace

/***
The analysis above uses the CPS ORG for 1979-2019 and the CPS May for 1973-1978.
***/
