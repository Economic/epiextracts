********************************************************************************
* Industry: 1990 classification
********************************************************************************
/* 1992-2002: 1990 census industry codes */
gen ind90 = .
if tm(1992m1) <= $date & $date <= tm(2002m12) {
	replace ind90 = indcode
}
label var ind90 "1990 Census Industry Classification"
notes ind90: Industry classification for 1992-2002
notes ind90: 1992-1993 Unicon: ind
notes ind90: 1994-2002 CPS: peio1icd
