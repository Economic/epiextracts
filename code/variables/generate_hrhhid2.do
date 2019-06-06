********************************************************************************
* hrhhid2
********************************************************************************
capture rename hrhhid2 orig_hrhhid2
gen hrhhid2 = ""

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(2004m4) {
		* not available
	}
	if tm(2004m5) <= $date {
		replace hrhhid2 = orig_hrhhid2
	}
}
lab var hrhhid2 "CPS: Household identifier (Part 2)"
notes hrhhid2: 2004m5-present: CPS household identifier, part 2
notes hrhhid2: Used for joining EPI extracts to BLS/Census raw data
