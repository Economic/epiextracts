* keep only 1976+ for annual data to avoid seasonality issues
keep if year >= 1976

gen byte primeepop = emp == 1 if emp ~= . & (25 <= age & age <= 54)
gen byte allepop = emp == 1 if emp ~= .

gcollapse (mean) primeepop allepop [pw=basicwgt], by(year) fast
sum year
local maxyear = r(max)
foreach var of varlist primeepop allepop {
	replace `var' = `var' * 100
	sum `var' if year == `maxyear'
	local `var'yvalue = r(mean)
	local `var'xvalue = `maxyear' + 0.5
}

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line allepop primeepop year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(55(5)75 80 "80%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'") ///
graphregion(color("252 252 252") margin(r=17)) plotregion(color("252 252 252")) ///
title("Employment-to-population ratios, overall and prime-age (25-54)", size(medium)) ///
text(`allepopyvalue' `allepopxvalue' "Overall", color("`color1'") placement(e)) ///
text(`primeepopyvalue' `primeepopxvalue' "Prime-age", color("`color2'") placement(e))
graph export ${variableimages}emp_titleimage.svg, replace
