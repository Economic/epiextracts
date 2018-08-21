*******************************************************************************
* Public sector: local
*******************************************************************************
gen byte publoc = .
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace publoc = 0 if class >= 1 & class ~= .
	replace publoc = 1 if class == 4
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace publoc = 0 if peio1cow >= 1 & peio1cow ~= .
	replace publoc = 1 if peio1cow == 3
}
lab var publoc "Local government employee"
lab def publoc 1 "In local government" 0 "Not in local government"
lab val publoc publoc
notes publoc: Different definitions/universes in 1989-1993, 1994-present
notes publoc: 1994-present: For first job only
notes publoc: 1989-1993 Unicon: class
notes publoc: 1994-present CPS: peio1cow
