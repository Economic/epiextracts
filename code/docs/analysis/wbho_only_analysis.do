keep if age >= 16 & age ~= .

cap drop hispanic

gen byte white = wbho_only == 1 if wbho_only ~= .
gen byte black = wbho_only == 2 if wbho_only ~= .
gen byte hispanic = wbho_only == 3 if wbho_only ~= .
gen byte other = wbho_only == 4 if wbho_only ~= .

gcollapse (mean) white black hispanic other [pw=basicwgt], by(year) fast
sum year
local maxyear = r(max)
foreach var of varlist white black hispanic other {
	replace `var' = `var' * 100
	sum `var' if year == `maxyear'
	local `var'yvalue = r(mean)
	local `var'xvalue = `maxyear' + 0.5
}

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163

line white black hispanic other year, ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(0(20)60 80 "80%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'" "`color3'" "`color4'") ///
graphregion(color(white) margin(r=17)) plotregion(color(white)) ///
title("Share of population by race/ethnicity, ages 16 and over, 1973-2018", size(medium)) ///
text(`whiteyvalue' `whitexvalue' "White only", color("`color1'") placement(e)) ///
text(`blackyvalue' `blackxvalue' "Black only", color("`color2'") placement(e)) ///
text(`hispanicyvalue' `hispanicxvalue' "Hispanic", color("`color3'") placement(e)) ///
text(`otheryvalue' `otherxvalue' "Other", color("`color4'") placement(e))
graph export ${variableimages}wbho_only_titleimage.svg, replace

/***
Significant race/ethnicity coding changes occur in 1989, 1996, 2003, 2012m5, and 2014.  

In the figure above, 1973-1975 data are from the EPI CPS May extracts, and 1976-2018 data are from the EPI CPS Basic Monthly extracts.
***/
