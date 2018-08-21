********************************************************************************
* hrsample
********************************************************************************
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	gen hrsample = ""
}
if tm(1994m1) <= $date & $date <= tm(2004m4) {
	* use already existing hrsample
}
if tm(2004m5) <= $date & $date <= tm(2018m5) {
	gen hrsample = ""
}
lab var hrsample "CPS: Household sample identifier"
notes hrsample: 1994-2004m4: CPS household sample
notes hrsample: Used for joining EPI extracts to BLS/Census raw data
