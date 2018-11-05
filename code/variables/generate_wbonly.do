********************************************************************************
* wbonly: White-only, Black-only, and other
********************************************************************************

gen byte wbonly = .
if tm(1973m1) <= $date & $date <= tm(1988m12) {
	replace wbonly = 1 if race == 1 /* White */
	replace wbonly = 2 if race == 2 /* Black */
	replace wbonly = 3 if race == 3 /* Other */
}
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace wbonly = 1 if race == 1 /* White */
	replace wbonly = 2 if race == 2 /* Black */
	replace wbonly = 3 if 3 <= race & race <= 5
}
if tm(1994m1) <= $date & $date <= tm(1995m12) {
	replace wbonly = 1 if perace == 1 /* White */
	replace wbonly = 2 if perace == 2 /* Black */
	replace wbonly = 3 if 3 <= perace & perace <= 5
}
if tm(1996m1) <= $date & $date <= tm(2002m12) {
	replace wbonly = 1 if perace == 1 /* White */
	replace wbonly = 2 if perace == 2 /* Black */
	replace wbonly = 3 if 3 <= perace & perace <= 4
}
if tm(2003m1) <= $date & $date <= tm(2012m4) {
	* May 2004- June 2005: ptdtrace variable renamed to prdtrace
	if tm(2004m5) <= $date & $date <= tm(2005m7) {
		*ptdtrace will exist due to generate_wbho.do. else:
		*gen ptdtrace = prdtrace
	}
	replace wbonly = 1 if ptdtrace == 1 /* White */
	replace wbonly = 2 if ptdtrace == 2 /* Black */
	replace wbonly = 3 if 3 <= ptdtrace & ptdtrace <= 21
}
if tm(2012m5) <= $date {
	replace wbonly = 1 if ptdtrace == 1 /* White */
	replace wbonly = 2 if ptdtrace == 2 /* Black */
	replace wbonly = 3 if 3 <= ptdtrace & ptdtrace <= 26
}

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
