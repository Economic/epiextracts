webdoc init ${variableanalysis}educ_detailed, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

local counter = 0
forvalues year = 1979(1)2017 {
	local counter = `counter' + 1
	unzipfile ${ceprdata}cepr_org_`year'.zip, replace
	if `counter' == 1 use year orgwgt educ age using cepr_org_`year', clear
	else append using cepr_org_`year', keep(year orgwgt educ age)
	erase cepr_org_`year'.dta
}

gen lths = educ == 1
gen hs = educ == 2
gen some = educ == 3
gen college = educ == 4
gen advanced = educ == 5

keep if age >= 25 & age ~= .

collapse (mean) lths hs some college advanced [pw=orgwgt], by(year)
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
graphregion(color("252 252 252")) plotregion(margin(r=15) color("252 252 252")) ///
title("Share of population age 25 and over by educational attainment, 1979-2017", size(medium)) ///
text(`lthsyvalue' `lthsxvalue' "LTHS", color("`color1'") placement(e)) ///
text(`hsyvalue' `hsxvalue' "HS", color("`color2'") placement(e)) ///
text(`someyvalue' `somexvalue' "Some college", color("`color3'") placement(e)) ///
text(`collegeyvalue' `collegexvalue' "College", color("`color4'") placement(e)) ///
text(`advancedyvalue' `advancedxvalue' "Advanced", color("`color5'") placement(e))
graph export ${variableanalysis}educ_titleimage.svg, replace
