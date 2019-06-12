********************************************************************************
* BASIC/MAY SAMPLE RESTRICTION
********************************************************************************
* only include those with non-missing, positive age
if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1997m12) {
		drop if age < 0
		assert age >= 0 & age ~= .
	}
	if tm(1998m1) <= $date {
		drop if a_age < 0
		assert a_age >= 0 & a_age ~= .
	}
}

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		drop if age == .
		assert age >= 0
	}
	if tm(1994m1) <= $date & $date <= tm(2012m4) {
		drop if peage < 0
		assert peage >= 0 & peage ~= .
	}
	if tm(2012m5) <= $date {
		drop if prtage < 0
		assert prtage >= 0 & prtage ~= .
	}
}
