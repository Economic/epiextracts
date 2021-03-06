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

lab var famwgt "Family weight"
notes famwgt: Family weight, based on head of family
notes famwgt: 1984-1993: Unicon famwgt
notes famwgt: 1994-present: CPS pwfmwgt
