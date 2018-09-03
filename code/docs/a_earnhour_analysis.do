keep if a_earnhour ~= .
keep if age >= 16 & age <= 64
keep if year >= 1979

gcollapse (mean) a_earnhour [pw=orgwgt], by(year) fast

replace a_earnhour = a_earnhour * 100

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line a_earnhour year if year <= 1988, lcolor("`color4'") || ///
line a_earnhour year if year >= 1989 & year <= 1993, lcolor("`color4'") || ///
line a_earnhour year if year >= 1995, lcolor("`color4'") ///
legend(off) ///
xlabel(1980(5)2015) ///
ylabel(0(10)40 50 "50%", angle(0)) ///
xtitle("") ytitle("") ///
lcolor("`color4'") ///
graphregion(color("252 252 252")) plotregion(color("252 252 252")) ///
title("Share of workforce with BLS allocated hourly earnings, ages 16-64, 1979-2017", size(medsmall))
graph export ${variableimages}a_earnhour_titleimage.svg, replace
