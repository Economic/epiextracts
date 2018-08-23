********************************************************************************
* BASIC/MAY SAMPLE RESTRICTION
********************************************************************************
* only include those with non-missing, positive age
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	drop if age == .
	assert age >= 0
}
if tm(1994m1) <= $date & $date <= tm(2012m4) {
	drop if peage < 0
	assert peage >= 0 & peage ~= .
}
if tm(2012m5) <= $date & $date <= tm(2018m5) {
	drop if prtage < 0
	assert prtage >= 0 & prtage ~= .
}
