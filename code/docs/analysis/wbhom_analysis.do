keep if age >= 16 & age ~= .
keep if wbhom ~= .

replace basicwgt = basicwgt/12
gcollapse (sum) count=basicwgt, by(wbhom)
sum count, d
local total = r(sum)
gen share = count / `total' * 100

gen str5 formatvalue = ""
levels wbhom, local(levels)
foreach l of numlist `levels' {
	sum share if wbhom == `l'
	local formatvalue`l': di %3.1f r(mean) "%"
	local formatyvalue`l' = r(mean)+2

}

gen share2 = share + 2

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0
local color6 166 86 40

twoway ///
bar share wbhom if wbhom == 1, barwidth(0.7) color("`color2'") || ///
bar share wbhom if wbhom == 2, barwidth(0.7) color("`color1'") || ///
bar share wbhom if wbhom == 3, barwidth(0.7) color("`color3'") || ///
bar share wbhom if wbhom == 4, barwidth(0.7) color("`color4'") || ///
bar share wbhom if wbhom == 5, barwidth(0.7) color("`color6'") ///
legend(off) ///
xlabel(,valuelabel labsize(small)) ///
ylabel(0(20)60 60 "60%", angle(0) gmin gmax) yscale(r(0 67)) ///
xtitle("") ytitle("") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Share of population by race/ethnicity, ages 16 and over, in 2018", size(medium)) ///
text(`formatyvalue1' 1 "`formatvalue1'", color("`color2'")) ///
text(`formatyvalue2' 2 "`formatvalue2'", color("`color1'")) ///
text(`formatyvalue3' 3 "`formatvalue3'", color("`color3'")) ///
text(`formatyvalue4' 4 "`formatvalue4'", color("`color4'")) ///
text(`formatyvalue5' 5 "`formatvalue5'", color("`color6'"))
graph export ${variableimages}wbhom_titleimage.svg, replace

/***
Significant race/ethnicity coding changes occur in 2012.
***/
