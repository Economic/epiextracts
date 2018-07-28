webdoc init ${variablelongdesc}unmem_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

keep if age >= 16 & selfemp == 0

gen wgt = orgwgt
replace wgt = basicwgt if year < 1983

gcollapse (mean) unmem [pw=wgt], by(year female) fast
reshape wide unmem, i(year) j(female)
foreach var of varlist unmem0 unmem1 {
	replace `var' = `var' * 100
	sum `var' if year == 1977
	local `var'yvalue = r(mean)
	local `var'xvalue = 1977
}

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

local unmem0yvalue = `unmem0yvalue' + 2.5
local unmem1yvalue = `unmem1yvalue' - 4


line unmem0 unmem1 year if year < 1982, lcolor("`color3'" "`color2'") || ///
line unmem0 unmem1 year if year > 1982, lcolor("`color3'" "`color2'") ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(0(5)30 35 "35%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Union members as a share of the workforce, by gender", size(medium)) ///
text(`unmem0yvalue' `unmem0xvalue' "Men", color("`color3'") placement(c)) ///
text(`unmem1yvalue' `unmem1xvalue' "Women", color("`color2'") placement(c))
graph export ${variableimages}unmem_titleimage.svg, replace
