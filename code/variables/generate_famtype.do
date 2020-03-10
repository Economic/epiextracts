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

if $marchcps == 1 {
	if tm(1976m1) <= $date & $date <= tm(1987m12) {
		replace famtype = 1 if famtyp == 0
		replace famtype = 2 if famtyp == 4
		replace famtype = 3 if famtyp == 3
		replace famtype = 4 if famtyp == 2
		replace famtype = 5 if famtyp == 1
	}
	if tm(1988m1) <= $date & $date <= tm(1997m12) {
		replace famtype = famtyp
	}
	if tm(1998m1) <= $date {
		replace famtype = a_famtyp
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
notes famtype: 1984-1993/1997: Unicon famtyp
notes famtype: 1994-present: CPS prfamtyp
notes famtype: 1998-present: March a_famtyp