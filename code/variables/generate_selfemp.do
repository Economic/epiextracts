*******************************************************************************
* Self-employed (unincorporated)
*******************************************************************************
gen byte selfemp = .

if $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace selfemp = 0 if class4 >= 1 & class4 != .
		replace selfemp = 1 if class4 == 3
	}
}

if $monthlycps == 1 {
	if tm(1976m1) <= $date & $date <= tm(1978m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 3
	}
	if tm(1979m1) <= $date & $date <= tm(1988m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 3
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 6
	}
	if tm(1994m1) <= $date {
		replace selfemp = 0 if peio1cow >= 1 & peio1cow != .
		replace selfemp = 1 if peio1cow == 7
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1962m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 3
	}
	if tm(1963m1) <= $date & $date <= tm(1988m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 3
	}
	if tm(1989m1) <= $date & $date <= tm(1997m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 6
	}
	if tm(1998m1) <= $date {
		replace selfemp = 0 if peio1cow >= 1 & peio1cow != .
		replace selfemp = 1 if peio1cow == 7
	}
}

lab var selfemp "Self-employed (unincorporated)"
lab def selfemp 1 "Self-employed" 0 "Not self-employed"
lab val selfemp selfemp
notes selfemp: Unincorporated self-employed only
notes selfemp: 1994-present CPS: peio1cow
notes selfemp: 1994-present: For first job
notes selfemp: 1976-1993 Unicon Basic: class
notes selfemp: 1973-1981 Unicon May: class4
notes selfemp: 1962-1997 Unicon March: class
notes selfemp: 1998-present CPS March: peio1cow
notes selfemp: Universe: Class of worker assigned (not necessarily employed)
notes selfemp: Different definitions/universes: 1973-1988, 1989-1993, 1994-present
