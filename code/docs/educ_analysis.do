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
	replace `ed' = `ed' * 100
	sum `ed' if year == `maxyear'
	local `ed'yvalue = r(mean)
	local `ed'xvalue = `maxyear' + 0.5
}

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line lths hs some college advanced year if year < 1992, ///
	lcolor("`color1'" "`color2'" "`color3'" "`color4'" "`color5'") || ///
line lths hs some college advanced year if year >= 1992, ///
	lcolor("`color1'" "`color2'" "`color3'" "`color4'" "`color5'") ///
	legend(off) ///
	xlabel(1975(5)2015) ///
	ylabel(0(5)35 40 "40%", angle(0) gmin gmax) ///
	xtitle("") ytitle("") ///
	graphregion(color("252 252 252") margin(r=21)) plotregion(color("252 252 252")) ///
	title("Share of population age 25 and over by educational attainment, 1973-2017", size(medium) span margin(l=20)) ///
	text(`lthsyvalue' `lthsxvalue' "Less than" "high school", color("`color1'") placement(r) justification(left)) ///
	text(`hsyvalue' `hsxvalue' "High school", color("`color2'") placement(r)) ///
	text(`someyvalue' `somexvalue' "Some college", color("`color3'") placement(r)) ///
	text(`collegeyvalue' `collegexvalue' "College", color("`color4'") placement(r)) ///
	text(`advancedyvalue' `advancedxvalue' "Advanced", color("`color5'") placement(r))
graph export ${variableimages}educ_titleimage.svg, replace

/***
some detailed analysis for educ
***/
