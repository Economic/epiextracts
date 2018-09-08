********************************************************************************
* Month in sample
********************************************************************************
gen byte minsamp = .
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	replace minsamp = mis
	assert minsamp >= 1 & minsamp <= 8
}
if tm(1994m1) <= $date {
	replace minsamp = hrmis
	assert minsamp >= 1 & minsamp <= 8
}
lab var minsamp "Month in sample"
notes minsamp: 1973 - 1993 Unicon: hrmis
notes minsamp: 1994 - present CPS: hrmis
