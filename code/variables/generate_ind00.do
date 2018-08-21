********************************************************************************
* Industry: 2000 classification
********************************************************************************
/* 2003-2012m4: 2000 census industry codes */
gen ind00 = .
if tm(2003m1) <= $date & $date <= tm(2012m4) {
	replace ind00 = indcode
}
label var ind00 "2000 Census Industry Classification"
notes ind00: Industry classification for 2003-2012m4
notes ind00: 2003-2012m4 CPS: peio1icd
