********************************************************************************
* hrsersuf
********************************************************************************
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	gen hrsersuf = ""
}
if tm(1994m1) <= $date & $date <= tm(2004m4) {
	* use already existing hrsersuf
}
if tm(2004m5) <= $date {
	gen hrsersuf = ""
}
lab var hrsersuf "CPS: Household serial suffix"
notes hrsersuf: 1994-2004m4: CPS household serial suffix
notes hrsersuf: Used for joining EPI extracts to BLS/Census raw data
