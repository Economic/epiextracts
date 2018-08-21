*******************************************************************************
* Public sector: federal
*******************************************************************************
gen byte pubfed = .
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace pubfed = 0 if class >= 1 & class ~= .
	replace pubfed = 1 if class == 2
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace pubfed = 0 if peio1cow >= 1 & peio1cow ~= .
	replace pubfed = 1 if peio1cow == 1
}
lab var pubfed "Federal government employee"
lab def pubfed 1 "In federal government" 0 "Not in federal government"
lab val pubfed pubfed
notes pubfed: Different definitions/universes in 1989-1993, 1994-present
notes pubfed: 1994-present: For first job only
notes pubfed: 1989-1993 Unicon: class
notes pubfed: 1994-present CPS: peio1cow
