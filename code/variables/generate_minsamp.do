********************************************************************************
* Month in sample
********************************************************************************
gen byte minsamp = .
if tm(1976m1) <= $date & $date <= tm(1993m12) {
	replace minsamp = mis
	assert minsamp >= 1 & minsamp <= 8
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace minsamp = hrmis
	assert minsamp >= 1 & minsamp <= 8
}
lab var minsamp "Month in sample"
notes minsamp: CPS: hrmis
