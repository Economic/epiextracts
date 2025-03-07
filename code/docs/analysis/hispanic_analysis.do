keep if age >= 16 & age ~= .

gcollapse (mean) hispanic [pw=basicwgt], by(year) fast
sum year
local maxyear = r(max)

replace hispanic = hispanic * 100
sum hispanic if year == `maxyear'
local hispanicyvalue = r(mean)
local hispanicxvalue = `maxyear' + 0.5

local color1 77 175 74
line hispanic year, ///
legend(off) ///
xlabel(1975(5)2020) ///
ylabel(0(10)40 50 "50%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color1'") ///
graphregion(color(white) margin(r=17)) plotregion(color(white)) ///
title("Hispanic share of population, ages 16 and over", size(medium)) ///
text(`hispanicyvalue' `hispanicxvalue' "Hispanic", color("`color1'") placement(e))
graph export ${variableimages}hispanic_titleimage.svg, replace

/***
Significant race/ethnicity coding changes occur in 1994, 2003, 2014.

In the figure above, 1973-1975 data are from the EPI CPS May extracts, and 1976-2024 data are from the EPI CPS Basic Monthly extracts.
***/
