*******************************************************************************
* Public sector: state
*******************************************************************************
gen byte pubst = .

if $monthlycps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace pubst = 0 if class >= 1 & class ~= .
		replace pubst = 1 if class == 3
	}
	if tm(1994m1) <= $date {
		replace pubst = 0 if peio1cow >= 1 & peio1cow ~= .
		replace pubst = 1 if peio1cow == 2
	}
}

if $marchcps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1997m12) {
		replace pubst = 0 if class >= 1 & class ~= .
		replace pubst = 1 if class == 3
	}
	if tm(1998m1) <= $date {
		replace pubst = 0 if peio1cow >= 1 & peio1cow ~= .
		replace pubst = 1 if peio1cow == 2
	}
}

lab var pubst "State government employee"
lab def pubst 1 "In state government" 0 "Not in state government"
lab val pubst pubst
notes pubst: Different definitions/universes in 1989-1993, 1994-present
notes pubst: 1994-present: For first job only
notes pubst: 1989-1993 Unicon Basic: class
notes pubst: 1994-present CPS Basic: peio1cow
notes publoc: 1989-1997 Unicon March: class
notes publoc: 1998-present CPS March: peio1cow
