********************************************************************************
* Family ID within household (hhid)
********************************************************************************
gen byte famid = .

if $monthlycps == 1 {
	if tm(1984m1) <= $date & $date <= tm(1993m12) {
		replace famid = famnum
	}
	if tm(1994m1) <= $date {
		replace famid = prfamnum
	}
}

if $marchcps == 1 {
	if tm(1963m1) <= $date & $date <= tm(1997m12) {
		replace famid = famnum
	}
	if tm(1998m1) <= $date & $date <= tm(2010m12) {
		replace famid = a_fmnum
	}
	if tm(2011m1) <= $date {
		replace famid = a_famnum
	}
}

lab def famid 0 "Not a family member"
lab def famid 1 "Primary family member only", add
forvalues i = 2/39 {
	lab def famid `i' "Subfamily no. `i' member", add
}
lab val famid famid
lab var famid "Family identifer (unique within household)"
notes famid: Family ID unique within year X month X hhid
notes famid: 1984-1993: Unicon famnum
notes famid: 1994-present: CPS famnum
