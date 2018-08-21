********************************************************************************
* pulineno
********************************************************************************
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	gen byte pulineno = .
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	* use already existing pulineno
}
lab var pulineno "CPS: Person line number within household"
notes pulineno: 1994-present: CPS person line number
notes pulineno: Used for joining EPI extracts to BLS/Census raw data
