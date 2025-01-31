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
	if tm(1962m1) <= $date & $date <= tm(1997m12) {
		if tm(1976m1) <= $date & $date <= tm(1976m12) {
			egen firstperson = min(perid), by(hhid famid)
			gen famwgt2 = .
			replace famwgt2 = asecwgt / 100 if perid == firstperson
			egen famwgt3 = mean(famwgt2), by(hhid famid)
			replace famwgt = famwgt3
			drop firstperson famwgt2 famwgt3
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
notes famwgt: 1984-1993 Unicon Basic: famwgt
notes famwgt: 1994-present CPS Basic: pwfmwgt
notes famwgt: 1963-1997 Unicon March: famwgt
notes famwgt: 1976 March: asecwgt (for first person in family)
notes famwgt: 1998-present CPS March: fsup_wgt
