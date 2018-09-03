********************************************************************************
* hrhhid2
********************************************************************************
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	gen hrhhid2 = ""
}
if tm(1994m1) <= $date & $date <= tm(2004m4) {
	gen hrhhid2 = ""
}
if tm(2004m5) <= $date {
	* use already existing hrhhid2
}
lab var hrhhid2 "CPS: Household identifier (Part 2)"
notes hrhhid2: 2004m5-present: CPS household identifier, part 2
notes hrhhid2: Used for joining EPI extracts to BLS/Census raw data
