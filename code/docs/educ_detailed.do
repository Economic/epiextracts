webdoc init ${variableanalysis}educ_detailed, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

local counter = 0
forvalues year = 1979(1)2017 {
	local counter = `counter' + 1
	unzipfile /home/bzipperer/cepr_org_`year'.zip, replace
	if `counter' == 1 use year orgwgt educ using cepr_org_`year', clear
	else append using cepr_org_`year', keep(year orgwgt educ)
	erase cepr_org_`year'.dta
}

gen lths = educ == 1
gen hs = educ == 2
gen some = educ == 3
gen college = educ == 4
gen advanced = educ == 5

collapse (mean) lths hs some college advanced [pw=orgwgt], by(year)
sum year
local maxyear = r(max)
foreach ed of varlist lths hs some college advanced {
	sum `ed' if year == `maxyear'
	local `ed'yvalue = r(mean)
	local `ed'xvalue = `maxyear' + 0.5
}
line lths hs some college advanced year, ///
legend(off) ///
xlabel(1980(5)2015) ///
xtitle("") ytitle("") ///
graphregion(color("252 252 252")) plotregion(margin(r=15) color("252 252 252")) ///
title("Share of population by race/ethnicity, 1979-2017", size(medium)) ///
text(`lthsyvalue' `lthsxvalue' "LTHS", color("`lthscolor'") placement(e)) ///
text(`hsyvalue' `hsxvalue' "HS", color("`hscolor'") placement(e)) ///
text(`someyvalue' `somexvalue' "Some college", color("`somecolor'") placement(e)) ///
text(`collegeyvalue' `collegexvalue' "College", color("`collegecolor'") placement(e)) ///
text(`advancedyvalue' `advancedxvalue' "Advanced", color("`advancedcolor'") placement(e))
graph export ${variableanalysis}educ_titleimage.svg, replace
