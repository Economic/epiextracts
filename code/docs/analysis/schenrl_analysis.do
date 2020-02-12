gen byte agegroup = 1 if age >= 16 & age <= 21
replace agegroup = 2 if age >= 22 & age <= 24
replace agegroup = 3 if age >= 25 & age <= 39
replace agegroup = 4 if age >= 40 & age <= 54

keep if agegroup ~= .
keep if year >= 1984

gcollapse (mean) schenrl_ = schenrl [pw=basicwgt], by(year agegroup) fast

* make wide
reshape wide schenrl_, i(year) j(agegroup)

* grab values useful for graphing
foreach var of varlist schenrl_* {
	replace `var' = `var' * 100
	sum `var' if year == 2013
	local `var'yvalue = r(mean)
	local `var'xvalue = 2007
}
local schenrl_1yvalue = `schenrl_1yvalue' + 6
local schenrl_2yvalue = `schenrl_2yvalue' + 5.5
local schenrl_3yvalue = `schenrl_3yvalue'
local schenrl_4yvalue = `schenrl_4yvalue'

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line schenrl_1 schenrl_2 year, ///
	lcolor("`color1'" "`color2'") || ///
	line schenrl_3 schenrl_4 year, ///
	lcolor("`color3'" "`color4'") ///
	legend(off) ///
	xlabel(1985(5)2015) ///
	ylabel(0(20)80 100 "100%", angle(0) gmin gmax) ///
	xtitle("") ytitle("") ///
	graphregion(color(white)) plotregion(color(white)) ///
	title("Share of individuals enrolled in school, by age group", size(medium)) ///
	text(`schenrl_1yvalue' `schenrl_1xvalue' "Ages 16-21", color("`color1'") placement(e)) ///
	text(`schenrl_2yvalue' `schenrl_2xvalue' "Ages 22-24", color("`color2'") placement(e)) ///
	text(`schenrl_3yvalue' `schenrl_3xvalue' "Ages 25-39", color("`color3'") placement(e)) ///
	text(`schenrl_4yvalue' `schenrl_4xvalue' "Ages 40-54", color("`color4'") placement(e))
	graph export ${variableimages}schenrl_titleimage.svg, replace
