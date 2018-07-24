webdoc init ${variablelongdesc}a_weekpay_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

keep if a_weekpay ~= .
keep if age >= 16 & age <= 64
keep if year >= 1979


gcollapse (mean) a_weekpay_ = a_weekpay [pw=orgwgt], by(year female) fast

* make wide and graph
reshape wide a_weekpay_, i(year) j(female)
foreach var of varlist a_weekpay_* {
	replace `var' = `var' * 100
	sum `var' if year == 2013
	local `var'yvalue = r(mean)
	local `var'xvalue = 2013
}
local a_weekpay_0yvalue = `a_weekpay_0yvalue' - 5
local a_weekpay_1yvalue = `a_weekpay_1yvalue' + 5

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line a_weekpay_0 a_weekpay_1 year if year <= 1993, lcolor("`color4'" "`color2'") || ///
line a_weekpay_0 a_weekpay_1 year if 1994 <= year, lcolor("`color4'" "`color2'") ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(0(20)80 100 "100%", angle(0)) ///
xtitle("") ytitle("") ///
lcolor("`color4'" "`color2'") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Share of workforce with BLS allocated weekly earnings, ages 16-64, by gender, 1979-2017", size(medium)) ///
text(`a_weekpay_0yvalue' `a_weekpay_0xvalue' "Male", color("`color4'") placement(c)) ///
text(`a_weekpay_1yvalue' `a_weekpay_1xvalue' "Female", color("`color2'") placement(c))
graph export ${variableimages}a_weekpay_titleimage.svg, replace
