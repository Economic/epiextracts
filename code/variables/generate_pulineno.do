********************************************************************************
* pulineno
********************************************************************************
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	gen byte pulineno = lineno
}
if tm(1994m1) <= $date {
	* use already existing pulineno
}
lab var pulineno "CPS: Person line number within household"
notes pulineno: 1973-1993: Unicon lineno
notes pulineno: 1994-present: CPS pulineno
notes pulineno: Used for joining EPI extracts to BLS/Census raw data
