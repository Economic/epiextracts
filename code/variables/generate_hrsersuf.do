********************************************************************************
* hrsersuf
********************************************************************************
capture rename hrsersuf orig_hrsersuf
gen hrsersuf = ""

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		* not available
	}
	if tm(1994m1) <= $date & $date <= tm(2004m4) {
		rename hrsersuf orig_hrsersuf
	}
	if tm(2004m5) <= $date {
		* not available
	}
}
lab var hrsersuf "CPS: Household serial suffix"
notes hrsersuf: 1994-2004m4: CPS household serial suffix
notes hrsersuf: Used for joining EPI extracts to BLS/Census raw data
