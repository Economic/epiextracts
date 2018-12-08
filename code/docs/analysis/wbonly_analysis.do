keep if age >= 16 & age ~= .

gen byte white = wbonly == 1 if wbonly ~= .
gen byte black = wbonly == 2 if wbonly ~= .
gen byte other = wbonly == 3 if wbonly ~= .

gcollapse (mean) white black other [pw=basicwgt], by(year) fast
sum year
local maxyear = r(max)
foreach var of varlist white black other {
	replace `var' = `var' * 100
	sum `var' if year == `maxyear'
	local `var'yvalue = r(mean)
	local `var'xvalue = `maxyear' + 0.5
}

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163

line white black other year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(0(20)60 80 "80%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'" "`color3'") ///
graphregion(color("252 252 252") margin(r=17)) plotregion(color("252 252 252")) ///
title("Share of population by race/ethnicity, ages 16 and over, 1973-2017", size(medium)) ///
text(`whiteyvalue' `whitexvalue' "White", color("`color1'") placement(e)) ///
text(`blackyvalue' `blackxvalue' "Black", color("`color2'") placement(e)) ///
text(`otheryvalue' `otherxvalue' "Other", color("`color3'") placement(e))
graph export ${variableimages}wbonly_titleimage.svg, replace

/***
Significant race/ethnicity coding changes occur in 1989, 1996, 2003, and 2012.

In the figure above, 1973-1975 data are from the EPI CPS May extracts, and 1976-2017 data are from the EPI CPS Basic Monthly extracts.
***/
