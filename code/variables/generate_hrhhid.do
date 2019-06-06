********************************************************************************
* hrhhid
********************************************************************************
capture rename hrhhid orig_hrhhid
gen hrhhid = ""

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
	  replace hrhhid = hhid
	}
	if tm(1994m1) <= $date {
	  replace hrhhid = orig_hrhhid
	}
}

lab var hrhhid "CPS: Household identifier (Part 1)"
notes hrhhid: 1973-1993 Unicon: hhid
notes hrhhid: 1994-present CPS: hrhhid
notes hrhhid: Used for joining EPI extracts to BLS/Census raw data
