********************************************************************************
* huhhnum
********************************************************************************
capture rename huhhnum orig_huhhnum
gen byte huhhnum = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		* not available
	}
	if tm(1994m1) <= $date & $date <= tm(2004m4) {
		replace huhhnum = orig_huhhnum
	}
	if tm(2004m5) <= $date {
	  * not available
	}
}

lab var huhhnum "CPS: Household number"
notes huhhnum: 1994-2004m4: CPS household number
notes huhhnum: Used for joining EPI extracts to BLS/Census raw data
