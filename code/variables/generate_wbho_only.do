********************************************************************************
* wbho_only: White-only, Black-only, Hispanic, and other
********************************************************************************
gen byte wbho_only = .
if tm(1973m1) <= $date & $date <= tm(1988m12) {
	replace wbho_only = 1 if race == 1 /* White */
	replace wbho_only = 2 if race == 2 /* Black */
	replace wbho_only = 4 if race == 4 /* Other */
  * Hispanic ethnicity
	replace wbho = 3 if hispanic == 1
}
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace wbho_only = 1 if race == 1 /* White */
	replace wbho_only = 2 if race == 2 /* Black */
	replace wbho_only = 4 if (3 <= race & race <= 5) /* Other */
	* Hispanic ethnicity
	replace wbho_only = 3 if hispanic == 1
}
if tm(1994m1) <= $date & $date <= tm(1995m12) {
	replace wbho_only = 1 if perace == 1 /* White */
	replace wbho_only = 2 if perace == 2 /* Black */
	replace wbho_only = 4 if 3 <= perace & perace <= 5 /* Other */
	* Hispanic ethnicity
	replace wbho_only = 3 if hispanic == 1
}
if tm(1996m1) <= $date & $date <= tm(2002m12) {
	replace wbho_only = 1 if perace == 1 /* White */
	replace wbho_only = 2 if perace == 2 /* Black */
	replace wbho_only = 4 if (3 <= perace & perace <= 4) /* Other */
	* Hispanic ethnicity
	replace wbho_only = 3 if hispanic == 1
}
if tm(2003m1) <= $date & $date <= tm(2012m4) {
	* May 2004- June 2005: ptdtrace variable renamed to prdtrace
	if tm(2004m5) <= $date & $date <= tm(2005m7) {
		*ptdtrace will exist due to generate_wbho.do. else:
		*gen ptdtrace = prdtrace
	}
	replace wbho_only = 1 if ptdtrace == 1 /* White */
	replace wbho_only = 2 if ptdtrace == 2 /* Black */
	replace wbho_only = 4 if 3 <= ptdtrace & ptdtrace <= 21 /* Other */
	* Hispanic ethnicity
	replace wbho_only = 3 if hispanic == 1
}
if tm(2012m5) <= $date {
	replace wbho_only = 1 if ptdtrace == 1 /* White */
	replace wbho_only = 2 if ptdtrace == 2 /* Black */
	replace wbho_only = 4 if 3 <= ptdtrace & ptdtrace <= 26 /* Other */
	* Hispanic ethnicity
	replace wbho_only = 3 if hispanic == 1
}

lab var wbho_only "Race: white only, black only, other"
#delimit ;
lab define wbho_only
1 "White only"
2 "Black only"
3 "Hispanic"
4 "Other"
;
#delimit cr
lab val wbho_only wbho_only
notes wbho_only: Racial and ethnic categories are mutually exclusive
notes wbho_only: Coding changes in 1989, 1996, 2003, 2012m5
notes wbho_only: Hispanic definition from variable hispanic
notes wbho_only: 1973-1993 Unicon: race
notes wbho_only: 1994-2002 CPS: perace
notes wbho_only: 2003-present CPS: ptdtrace
