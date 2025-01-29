*******************************************************************************
* Incorporated self-employed
*******************************************************************************
gen byte selfinc = .

if $monthlycps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace selfinc = 0 if class >= 1 & class != .
		replace selfinc = 1 if class == 5
	}
	if tm(1994m1) <= $date {
		replace selfinc = 0 if peio1cow >= 1 & peio1cow != .
		replace selfinc = 1 if peio1cow == 6
	}
}

if $marchcps == 1 {
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		replace selfinc = 0 if cowjob1 >= 1 & cowjob1 != .
		replace selfinc = 1 if cowjob1 == 6
	}
	if tm(1998m1) <= $date {
		replace selfinc = 0 if peio1cow >= 1 & peio1cow != .
		replace selfinc = 1 if peio1cow == 6
	}
}

lab var selfinc "Incorporated self-employed"
lab def selfinc 1 "Self-employed (incorp)" 0 "Not self-employed (incorp)"
lab val selfinc selfinc
notes selfinc: Incorporated self-employed only
notes selfinc: 1994-present CPS Basic: peio1cow
notes selfinc: 1994-present: For first job
notes selfinc: 1989-1993 Unicon Basic: derived from class
notes selfinc: 1994-1997 Unicon March: cowjob1
notes selfinc: 1998-present CPS March: peio1cow
notes selfinc: Universe: Class of worker assigned (not necessarily employed)
notes selfinc: Different definitions/universes: 1989-1993, 1994-present
