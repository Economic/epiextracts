********************************************************************************
* Occupation: 1970 classification
****************************************************************
* for coding ease, first create occupation code for all dates
gen int occcode = .
if tm(1973m1) <= $date & $date <= tm(1993m12)	{
	replace occcode = occ
}
if tm(1994m1) <= $date {
	replace occcode = peio1ocd
}

* 1973-1982: 1970 census occupation codes
* occ70 is already a variable, drop if it exists
capture drop occ70
gen occ70 = .
replace occ70 = occcode if tm(1973m1) <= $date & $date <= tm(1982m12)
label var occ70 "1970 Census Occupation Classification"
notes occ70: Occupation classification for 1973-1982
notes occ70: 1973-1982 Unicon: occ
