keep if a_weekpay ~= .
keep if age >= 16 & age <= 64
keep if year >= 1979

gcollapse (mean) a_weekpay [pw=orgwgt], by(year) fast

replace a_weekpay = a_weekpay * 100

local color1 228 26 28
local color2 55 126 184
local color3 77 175 74
local color4 152 78 163
local color5 255 127 0

line a_weekpay year if year <= 1988, lcolor("`color4'") || ///
line a_weekpay year if year >= 1989 & year <= 1993, lcolor("`color4'") || ///
line a_weekpay year if year >= 1995, lcolor("`color4'") ///
legend(off) ///
xlabel(1980(5)2015) ///
ylabel(0(10)40 50 "50%", angle(0) gmin gmax) ///
xtitle("") ytitle("") ///
lcolor("`color4'") ///
graphregion(color(white)) plotregion(color(white)) ///
title("Share of workforce with BLS allocated weekly earnings, ages 16-64, 1979-2018", size(medsmall))
graph export ${variableimages}a_weekpay_titleimage.svg, replace
