********************************************************************************
* hrsample
********************************************************************************
capture rename hrsample orig_hrsample
gen hrsample = ""

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		* not available
	}
	if tm(1994m1) <= $date & $date <= tm(2004m4) {
		replace hrsample = orig_hrsample
	}
	if tm(2004m5) <= $date {
		* not available
	}
}


lab var hrsample "CPS: Household sample identifier"
notes hrsample: 1994-2004m4: CPS household sample
notes hrsample: Used for joining EPI extracts to BLS/Census raw data
