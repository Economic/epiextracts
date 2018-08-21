********************************************************************************
* huhhnum
********************************************************************************
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	gen byte huhhnum = .
}
if tm(1994m1) <= $date & $date <= tm(2004m4) {
	* use already existing huhhnum
}
if tm(2004m5) <= $date & $date <= tm(2018m5) {
  gen byte huhhnum = .
}
lab var huhhnum "CPS: Household number"
notes huhhnum: 1994-2004m4: CPS household number
notes huhhnum: Used for joining EPI extracts to BLS/Census raw data
