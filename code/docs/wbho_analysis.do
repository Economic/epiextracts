webdoc init ${variablelongdesc}wbho_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

gen byte white = wbho == 1 if wbho ~= .
gen byte black = wbho == 2 if wbho ~= .
gen byte hispanic = wbho == 3 if wbho ~= .
gen byte other = wbho == 4 if wbho ~= .

collapse (mean) white black hispanic other [pw=basicwgt], by(year) fast
sum year
local maxyear = r(max)
foreach race of varlist white black hispanic other {
	sum `race' if year == `maxyear'
	local `race'yvalue = r(mean)
	local `race'xvalue = `maxyear' + 0.5
}

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163

line white black hispanic other year, ///
legend(off) ///
xlabel(1980(5)2015) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'" "`color3'" "`color4'") ///
graphregion(color("252 252 252")) plotregion(margin(r=15) color("252 252 252")) ///
title("Share of population by race/ethnicity, ages 16 and over, 1979-2017", size(medium)) ///
text(`whiteyvalue' `whitexvalue' "White", color("`color1'") placement(e)) ///
text(`blackyvalue' `blackxvalue' "Black", color("`color2'") placement(e)) ///
text(`hispanicyvalue' `hispanicxvalue' "Hispanic", color("`color3'") placement(e)) ///
text(`otheryvalue' `otherxvalue' "Other", color("`color4'") placement(e))
graph export ${variableimages}wbho_titleimage.svg, replace

/***
well, this is my detailed analysis for wbho
***/
