********************************************************************************
* Occupation: 1990 classification
********************************************************************************
/* 1992-2002: 1990 census occupation codes */
gen occ90 = .
if tm(1992m1) <= $date & $date <= tm(2002m12) {
	replace occ90 = occcode
}
label var occ90 "1990 Census Occupation Classification"
notes occ90: Occupation classification for 1992-2002
notes occ90: 1992-1993 Unicon: occ
notes occ90: 1994-2002 CPS: peio1ocd
