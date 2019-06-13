********************************************************************************
* Family type
********************************************************************************
gen famtype = .

if $monthlycps == 1 {
	if tm(1984m1) <= $date & $date <= tm(1993m12) {
		replace famtype = famtyp
	}
	if tm(1994m1) <= $date {
		replace famtype = prfamtyp
	}
}

#delimit ;
lab def famtype
1 "Primary family"
2 "Primary individual"
3 "Related subfamily"
4 "Unrelated secondary family"
5 "Unrelated secondary individual"
;
#delimit cr;
lab val famtype famtype
lab var famtype "Family type"
notes famtype: Type of family
notes famtype: 1984-1993: Unicon famtyp
notes famtype: 1994-present: CPS prfamtyp
