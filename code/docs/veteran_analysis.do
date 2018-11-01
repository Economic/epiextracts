keep if veteran ~= .
keep if age >= 18 & age ~= .
keep if female == 0

gcollapse (mean) veteran [pw=basicwgt], by(year) fast

replace veteran = veteran * 100

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line veteran year, lcolor("`color4'") ///
legend(off) ///
xlabel(1975(5)2015) ///
ylabel(0(10)40 50 "50%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Veteran status of men, ages 18 and above, 1973-2017", size(medsmall))
graph export ${variableimages}veteran_titleimage.svg, replace
