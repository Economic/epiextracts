********************************************************************************
* Industry: 1980 classification
********************************************************************************
/* 1983-1991: 1980 census industry codes */
gen ind80 = .
if tm(1983m1) <= $date & $date <= tm(1991m12) {
	replace ind80 = indcode
}
label var ind80 "1980 Census Industry Classification"
notes ind80: Industry classification for 1983-1991
notes ind80: 1983-1991 Unicon: ind
