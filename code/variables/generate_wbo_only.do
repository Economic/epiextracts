********************************************************************************
* wbo_only: White-only, Black-only, and other
********************************************************************************

gen byte wbo_only = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1988m12) {
		replace wbo_only = 1 if race == 1 /* White */
		replace wbo_only = 2 if race == 2 /* Black */
		replace wbo_only = 3 if race == 3 /* Other */
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace wbo_only = 1 if race == 1 /* White */
		replace wbo_only = 2 if race == 2 /* Black */
		replace wbo_only = 3 if 3 <= race & race <= 5
	}
	if tm(1994m1) <= $date & $date <= tm(1995m12) {
		replace wbo_only = 1 if perace == 1 /* White */
		replace wbo_only = 2 if perace == 2 /* Black */
		replace wbo_only = 3 if 3 <= perace & perace <= 5
	}
	if tm(1996m1) <= $date & $date <= tm(2002m12) {
		replace wbo_only = 1 if perace == 1 /* White */
		replace wbo_only = 2 if perace == 2 /* Black */
		replace wbo_only = 3 if 3 <= perace & perace <= 4
	}
	if tm(2003m1) <= $date & $date <= tm(2012m4) {
		* May 2004- June 2005: ptdtrace variable renamed to prdtrace
		if tm(2004m5) <= $date & $date <= tm(2005m7) {
			*ptdtrace will exist due to generate_wbho.do. else:
			*gen ptdtrace = prdtrace
		}
		replace wbo_only = 1 if ptdtrace == 1 /* White */
		replace wbo_only = 2 if ptdtrace == 2 /* Black */
		replace wbo_only = 3 if 3 <= ptdtrace & ptdtrace <= 21
	}
	if tm(2012m5) <= $date {
		replace wbo_only = 1 if ptdtrace == 1 /* White */
		replace wbo_only = 2 if ptdtrace == 2 /* Black */
		replace wbo_only = 3 if 3 <= ptdtrace & ptdtrace <= 26
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1962m12) {
    	replace wbo_only = 1 if race == 0
    	replace wbo_only = 2 if race == 1
    	replace wbo_only = 3 if race == 2
	}
	if tm(1963m1) <= $date & $date <= tm(1987m12) {
	    replace wbo_only = 1 if race == 1 
	    replace wbo_only = 2 if race == 2
	    replace wbo_only = 3 if race == 3
	}
	if tm(1988m1) <= $date & $date <= tm(1995m12) {
	    replace wbo_only = 1 if race == 1
	    replace wbo_only = 2 if race == 2
	    replace wbo_only = 3 if 4 <= race & race <= 5
	}
	if tm(1996m1) <= $date & $date <= tm(1997m12) {
	    replace wbo_only = 1 if race == 1
	    replace wbo_only = 2 if race == 2
	    replace wbo_only = 3 if 3 <= race
	}
	if tm(1998m1) <= $date & $date <= tm(2002m12) {
	    replace wbo_only = 1 if a_race == 1
	    replace wbo_only = 2 if a_race == 2
	    replace wbo_only = 3 if 3 <= a_race
	}
	if tm(2003m1) <= $date {
	    replace wbo_only = 1 if prdtrace == 1
	    replace wbo_only = 2 if prdtrace == 2
	    replace wbo_only = 3 if 3 <= prdtrace
	}
}

lab var wbo_only "Race: white only, black only, other"
#delimit ;
lab define wbo_only
1 "White only"
2 "Black only"
3 "Other"
;
#delimit cr
lab val wbo_only wbo_only
notes wbo_only: Coding changes in 1989, 1996, 2003, 2012m5
notes wbo_only: 1973-1993 May/Basic: race
notes wbo_only: 1994-2002 May/Basic: perace
notes wbo_only: 2003-present May/Basic: ptdtrace
notes wbo_only: 1962-1997 March: race
notes wbo_only: 1998-2002 March: a_race
notes wbo_only: 2003-present March: prdtrace
