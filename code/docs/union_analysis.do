webdoc init ${variablelongdesc}union_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

keep if age >= 16 & selfany == 0

gen wgt = orgwgt
replace wgt = basicwgt if year < 1983

collapse (mean) unmem union [pw=wgt], by(year) fast
foreach var of varlist unmem union {
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

local unmemyvalue = `unmemyvalue' - 3
local unionyvalue = `unionyvalue' + 2


line unmem union year if year < 1982, lcolor("`color3'" "`color2'") || ///
line unmem union year if year > 1982, lcolor("`color3'" "`color2'") ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(0(5)25 30 "30%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Union representation and membership as a share of the workforce", size(medium)) ///
text(`unmemyvalue' `unmemxvalue' "Membership", color("`color3'") placement(c)) ///
text(`unionyvalue' `unionxvalue' "Representation", color("`color2'") placement(c))
graph export ${variableimages}union_titleimage.svg, replace
