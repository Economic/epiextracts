********************************************************************************
* pulineno
********************************************************************************
capture rename pulineno orig_pulineno
gen byte pulineno = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		replace pulineno = lineno
	}
	if tm(1994m1) <= $date {
		replace pulineno = orig_pulineno
	}
}

if $marchcps == 1 {
	if tm(1973m1) <= $date {
		replace pulineno = a_lineno
	}
}

lab var pulineno "CPS: Person line number within household"
notes pulineno: 1973-1993: Unicon lineno
notes pulineno: 1994-present: CPS pulineno
notes pulineno: 1973-present: March pulineno
notes pulineno: Used for joining EPI extracts to BLS/Census raw data
