webdoc init ${variablelongdesc}educ_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

gen byte lths = educ == 1 if educ ~= .
gen byte hs = educ == 2 if educ ~= .
gen byte some = educ == 3 if educ ~= .
gen byte college = educ == 4 if educ ~= .
gen byte advanced = educ == 5 if educ ~= .

keep if age >= 25 & age ~= .

collapse (mean) lths hs some college advanced [pw=basicwgt], by(year) fast
sum year
local maxyear = r(max)
foreach ed of varlist lths hs some college advanced {
	sum `ed' if year == `maxyear'
	local `ed'yvalue = r(mean)
	local `ed'xvalue = `maxyear' + 0.5
}

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line lths hs some college advanced year, ///
legend(off) ///
xlabel(1980(5)2015) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'" "`color3'" "`color4'" "`color5'") ///
graphregion(color("252 252 252")) plotregion(margin(r=17) color("252 252 252")) ///
title("Share of population age 25 and over by educational attainment, 1979-2017", size(medium)) ///
text(`lthsyvalue' `lthsxvalue' "LTHS", color("`color1'") placement(e)) ///
text(`hsyvalue' `hsxvalue' "HS", color("`color2'") placement(e)) ///
text(`someyvalue' `somexvalue' "Some college", color("`color3'") placement(e)) ///
text(`collegeyvalue' `collegexvalue' "College", color("`color4'") placement(e)) ///
text(`advancedyvalue' `advancedxvalue' "Advanced", color("`color5'") placement(e))
graph export ${variableimages}educ_titleimage.svg, replace

/***
some detailed analysis for educ
***/
