********************************************************************************
* Industry code
********************************************************************************
gen int indcode = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		replace indcode = ind
	}
	if tm(1994m1) <= $date {
		replace indcode = peio1icd
		replace indcode = . if indcode < 0
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1997m12) {
		replace indcode = ind
	}
	if tm(1998m1) <= $date & $date <= tm(2002m12) {
		replace indcode = a_ind
	}
	if tm(2003m1) <= $date {
		replace indcode = peioind
	}
}

lab var indcode "Industry: original census code"
notes indcode: Not consistent over time
notes indcode: 1973-1993/1997 Unicon: ind
notes indcode: 1994-present CPS basic/may: peio1icd
notes indcode: 1998-2002 CPS march: a_ind
notes indcode: 2003-present CPS march: peionind