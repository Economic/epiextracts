********************************************************************************
* Family weight
********************************************************************************
capture rename famwgt oldfamwgt
gen famwgt = .

if $monthlycps == 1 {
	if tm(1984m1) <= $date & $date <= tm(1993m12) {
		replace famwgt = oldfamwgt / 100
	}
	if tm(1994m1) <= $date {
		replace famwgt = pwfmwgt / 10000
	}
}

if $marchcps == 1 {
	if tm(1963m1) <= $date & $date <= tm(1997m12) {
		if tm(1976m1) <= $date & $date <= tm(1976m12) {
			replace famwgt = asecwgt / 100 if famid == 1
		}
		else {
			replace famwgt = oldfamwgt / 100
		}
	}
	if tm(1998m1) <= $date {
		replace famwgt = fsup_wgt / 100
	}
}

lab var famwgt "Family weight"
notes famwgt: Family weight, based on head of family
notes famwgt: 1984-1993: Unicon famwgt
notes famwgt: 1994-present: CPS pwfmwgt
