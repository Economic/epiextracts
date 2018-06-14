webdoc init ${variablelongdesc}emp_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

gen byte primeepop = emp == 1 if emp ~= . & (25 <= age & age <= 54)
gen byte allepop = emp == 1 if emp ~= .

collapse (mean) primeepop allepop [pw=basicwgt], by(year) fast
sum year
local maxyear = r(max)
foreach var of varlist primeepop allepop {
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
xlabel(1980(5)2015) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'") ///
graphregion(color("252 252 252")) plotregion(margin(r=17) color("252 252 252")) ///
title("Employment-to-population ratios, overall and prime-age (25-54)", size(medium)) ///
text(`allepopyvalue' `allepopxvalue' "Overall", color("`color1'") placement(e)) ///
text(`primeepopyvalue' `primeepopxvalue' "Prime-age", color("`color2'") placement(e))
graph export ${variableimages}emp_titleimage.svg, replace
