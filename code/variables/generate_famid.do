********************************************************************************
* Family ID within household (hhid)
********************************************************************************
gen famid = .
if tm(1984m1) <= $date & $date <= tm(1993m12) {
	replace famid = famnum
}
if tm(1994m1) <= $date {
	replace famid = prfamnum
}
lab def famnum 0 "Not a family member"
lab def famnum 1 "Primary family member only", add
forvalues i = 2/39 {
	lab def famnum `i' "Subfamily no. `i' member", add
}
lav val famid famid
lab var famid "Family identifer (unique within household)"
notes famid: Family ID unique within year X month X hhid
notes famid: 1984-1993: Unicon famnum
notes famid: 1994-present: CPS famnum
