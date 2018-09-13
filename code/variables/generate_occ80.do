********************************************************************************
* Occupation: 1980 classification
********************************************************************************
/* 1983-1991: 1980 census occupation codes */
gen occ80 = .
if tm(1983m1) <= $date & $date <= tm(1991m12) {
	replace occ80 = occcode
}
label var occ80 "1980 Census Occupation Classification"
notes occ80: Occupation classification for 1983-1991
notes occ80: 1983-1991 Unicon: occ
