keep if age >= 16 & age ~= .
keep if wbhao ~= .

cap drop hispanic

gen byte white = wbhao == 1
gen byte black = wbhao == 2
gen byte hispanic = wbhao == 3
gen byte asian = wbhao == 4
gen byte other = wbhao == 5

gcollapse (mean) white black hispanic asian other [pw=basicwgt], by(year) fast
sum year
local maxyear = r(max)
foreach var of varlist white black hispanic asian other {
	replace `var' = `var' * 100
	sum `var' if year == `maxyear'
	local `var'yvalue = r(mean)
	local `var'xvalue = `maxyear' + 0.5
}

* http://colorbrewer2.org/#type=qualitative&scheme=Set1&n=5
local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line white black hispanic asian other year, ///
legend(off) ///
xlabel(1990(5)2015) ///
ylabel(0(20)60 80 "80%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'" "`color3'" "`color4'" "`color5'") ///
graphregion(color(white) margin(r=17)) plotregion(color(white)) ///
title("Share of population by race/ethnicity, ages 16 and over, 1989-2018", size(medium)) ///
text(`whiteyvalue' `whitexvalue' "White", color("`color1'") placement(e)) ///
text(`blackyvalue' `blackxvalue' "Black", color("`color2'") placement(e)) ///
text(`hispanicyvalue' `hispanicxvalue' "Hispanic", color("`color3'") placement(e)) ///
text(`asianyvalue' `asianxvalue' "Asian", color("`color4'") placement(e)) ///
text(`otheryvalue' `otherxvalue' "Other", color("`color5'") placement(e))
graph export ${variableimages}wbhao_titleimage.svg, replace

/***
Significant race/ethnicity coding changes occur in 1989, 1996, 2003, 2012m5, and 2014.  
***/
