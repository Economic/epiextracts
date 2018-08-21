********************************************************************************
* Industry: 1970 classification
********************************************************************************
********************************************************************************
* Industry variables for each period
********************************************************************************
gen int indcode = .
if tm(1973m1) <= $date & $date <= tm(1993m12)	{
	replace indcode = ind
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace indcode = peio1icd
}
* 1973-1982: 1970 census industry codes
* ind70 is already a variable, drop if it exists
capture drop ind70
gen ind70 = .
replace ind70 = indcode if tm(1973m1) <= $date & $date <= tm(1982m12)
label var ind70 "1970 Census Industry Classification"
notes ind70: Industry classification for 1973-1982
notes ind70: 1973-1982 Unicon: ind
