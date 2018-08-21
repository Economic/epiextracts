********************************************************************************
* Industry: 2010 classification
********************************************************************************
/* 2012m5-present: 2010 census industry codes */
gen ind10 = .
if tm(2012m5) <= $date & $date <= tm(2018m5) {
	replace ind10 = indcode
}
label var ind10 "2010 Census Industry Classification"
notes ind10: Industry classification for 2012m5-present
notes ind10: 2012m5-present CPS: peio1icd
