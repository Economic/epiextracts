* restrict to sample when ages 0+ are available
keep if year >= 1982

gen byte child = age >= 0 & age <= 15
gen byte young = age >= 16 & age <= 24
gen byte early = age >= 25 & age <= 39
gen byte mid = age >= 40 & age <= 54
gen byte late = age >= 55 & age <= 64
gen byte old = age >= 65 & age <= 80

egen byte total = rowtotal(child young early mid late old)
assert total == 1

gcollapse (mean) child young early mid late old [pw=finalwgt], by(year) fast
foreach var of varlist child young early mid late old {
	replace `var' = `var' * 100
	sum `var' if year == 1987
	local `var'yvalue = r(mean)
	local `var'xvalue = 1987
}
local childyvalue = `childyvalue' - 1.1
local youngyvalue = `youngyvalue' + 0.9
local earlyyvalue = `earlyyvalue' + 1.0
local midyvalue = `midyvalue' + 3.0
local lateyvalue = `lateyvalue' - 1.9
local oldyvalue = `oldyvalue' - 0.7

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0
local color6 166 86 40


line child young early mid late old year, ///
legend(off) ///
xlabel(1985(5)2015) ///
ylabel(5(5)20 25 "25%", angle(0) gmin gmax) ///
yscale(r(5 27)) ///
xtitle("") ytitle("") ///
lcolor("`color1'" "`color2'" "`color3'" "`color4'" "`color5'" "`color6'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Share of civilian population by age group, 1982-2018", size(medium)) ///
text(`childyvalue' `childxvalue' "Ages 0-15", color("`color1'") placement(r)) ///
text(`youngyvalue' `youngxvalue' "Ages 16-24", color("`color2'") placement(r)) ///
text(`earlyyvalue' `earlyxvalue' "Ages 25-39", color("`color3'") placement(r)) ///
text(`midyvalue' `midxvalue' "Ages 40-54", color("`color4'") placement(r)) ///
text(`lateyvalue' `latexvalue' "Ages 55-64", color("`color5'") placement(r)) ///
text(`oldyvalue' `oldxvalue' "Ages 65+", color("`color6'") placement(r))
graph export ${variableimages}age_titleimage.svg, replace

/***
The minimum age of the sample in the CPS extracts is consistent since 1982. However, in 1985, about 16-17% of observations ages 0-13 have zero values for finalwgt. The zero weight values in that year explain the spike in (sample-weighted) age shares illustrated above.
***/
