keep if age >= 16 & age ~= .
keep if ptecon ~= .
keep if lfstat == 1

cap drop hispanic

gen byte white = ptecon == 1 if wbho == 1
gen byte black = ptecon == 1 if wbho == 2
gen byte hispanic = ptecon == 1 if wbho == 3
gen byte other = ptecon == 1 if wbho == 4

gcollapse (mean) white black hispanic other [pw=basicwgt], by(year) fast
foreach var of varlist white black hispanic other {
	replace `var' = `var' * 100
}

sum year
local maxyear = r(max)
foreach var of varlist white black hispanic other {
	sum `var' if year == `maxyear'
	local `var'yvalue = r(mean)
	local `var'xvalue = `maxyear' - 0.2
}
local hispanicyvalue = `hispanicyvalue' + 0.5
local blackyvalue = `blackyvalue' - 0.5
local otheryvalue = `otheryvalue' + 0.5
local whiteyvalue = `whiteyvalue' - 0.5

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163

line white black hispanic other year if year <= 1993, ///
lcolor("`color1'" "`color2'" "`color3'" "`color4'") || ///
line white black hispanic other year if year >= 1994, ///
lcolor("`color1'" "`color2'" "`color3'" "`color4'") ///
legend(off) ///
xlabel(1990(5)2020) ///
ylabel(0(2)10 12 "12%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
graphregion(color(white) margin(r=12)) plotregion(color(white)) ///
title("Working part-time for economic reasons as a share of employment", size(medium)) ///
text(`whiteyvalue' `whitexvalue' "White", color("`color1'") placement(e)) ///
text(`blackyvalue' `blackxvalue' "Black", color("`color2'") placement(e)) ///
text(`hispanicyvalue' `hispanicxvalue' "Hispanic", color("`color3'") placement(e)) ///
text(`otheryvalue' `otherxvalue' "Other", color("`color4'") placement(e))
graph export ${variableimages}ptecon_titleimage.svg, replace
