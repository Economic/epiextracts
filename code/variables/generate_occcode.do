********************************************************************************
* Occupation code
********************************************************************************
gen int occcode = .
if tm(1973m1) <= $date & $date <= tm(1993m12)	{
	replace occcode = occ
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace occcode = peio1ocd
}
lab var occcode "Occupation: original census code"
notes occcode: Not consistent over time
notes occcode: 1973-1993 Unicon: occ
notes occcode: 1994-present CPS: peio1ocd
