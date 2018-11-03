********************************************************************************
* wbonly: White-only, Black-only, and other
********************************************************************************
gen byte wbonly = .
replace wbonly = 1 if raceorig == 1
replace wbonly = 2 if raceorig == 2
replace wbonly = 3 if raceorig >= 3 & raceorig ~= .

lab var wbonly "Race: white only, black only, other"
#delimit ;
lab define wbonly
1 "White only"
2 "Black only"
3 "Other"
;
#delimit cr
lab val wbonly wbonly
notes wbonly: Coding changes in 1989, 1996, 2003, 2012m5
notes wbonly: 1973-1993 Unicon: race
notes wbonly: 1994-2002 CPS: perace
notes wbonly: 2003-present CPS: ptdtrace
