********************************************************************************
* Occupation: 2010 classification
********************************************************************************
/* 2012m5-present: 2010 census occupation codes */
gen occ10 = .
if tm(2012m5) <= $date {
	replace occ10 = occcode
}
label var occ10 "2010 Census Occupation Classification"
notes occ10: Occupation classification for 2012m5-present
notes occ10: 2012m5-present CPS: peio1ocd
