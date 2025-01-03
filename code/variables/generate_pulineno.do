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
	if tm(1962m1) <= $date & $date <= tm(1997m12) {
		if tm(1976m1) <= $date & $date <= tm(1978m12) {
			replace pulineno = .
		}
		else {
			replace pulineno = lineno
		}
	}
	if tm(1998m1) <= $date {
		replace pulineno = a_lineno
	}
}

lab var pulineno "CPS: Person line number within household"
notes pulineno: 1973-1993 Unicon Basic: lineno
notes pulineno: 1994-present CPS Basic: pulineno
notes pulineno: 1962-1997 Unicon March: lineno
notes pulineno: 1998-present CPS March: a_lineno
notes pulineno: Used for joining EPI extracts to BLS/Census raw data
notes pulineno: Data missing 1976-1978
