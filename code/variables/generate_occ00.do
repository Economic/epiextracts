********************************************************************************
* Occupation: 2000 classification
********************************************************************************
/* 2003-2012m4: 2000 census occupation codes */
gen occ00 = .
if tm(2003m1) <= $date & $date <= tm(2012m4) {
	replace occ00 = occcode
}
label var occ00 "2000 Census Occupation Classification"
notes occ00: Occupation classification for 2003-2012m4
notes occ00: 2003-2012m4 CPS: peio1ocd
