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

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1997m12) {
		replace hrhhid = hhid
	}
	if tm(1998m1) <= $date & $date <= tm(2004m12) {
		replace hrhhid = h_idnum
	}
	if tm(2005m1) <= $date & $date <= tm(2018m12){
		replace hrhhid = h_idnum1
	}
	if tm(2019m1) <= $date {
		tostring h_idnum, replace force
		replace hrhhid = h_idnum
	}
}

lab var hrhhid "CPS: Household identifier (Part 1)"
notes hrhhid: 1973-1993 May/Basic: hhid
notes hrhhid: 1994-present May/Basic: hrhhid
notes hrhhid: 1962-1997 March: hhid
notes hrhhid: 1998-2004 March: h_idnum
notes hrhhid: 2005-2018 March: h_idnum
notes hrhhid: Used for joining EPI extracts to BLS/Census raw data
