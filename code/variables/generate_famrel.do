*******************************************************************************
* Family relationship recode
*******************************************************************************
cap drop famrel
cap lab drop famrel
capture rename famrel oldfamrel

gen byte famrel = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace famrel = prfamrel if prfamrel >= 0
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1967m12) {
		replace famrel = 0 if oldfamrel == 4
		replace famrel = oldfamrel + 1
	}
	if tm(1988m1) <= $date & $date <= tm(1997m12) {
		replace famrel = oldfamrel
	}
	if tm(1998m1) <= $date {
		replace famrel = a_famrel if a_famrel >= 0
	}

}

lab var famrel "Family relationship recode"
#delimit ;
lab define famrel
0 "Not a family member"
1 "Reference person"
2 "Spouse"
3 "Child"
4 "Other relative (primary family & unrelated)"
;
#delimit cr
lab val famrel famrel
notes famrel: Census recode of family relationship
notes famrel 1976-1987 March: famrel only breaksdown sub- and secondary families, excluded
notes famrel: 1994-present CPS Basic: prfamrel
notes famrel: 1962-1997 Unicon March: famrel
notes famrel: 1998-present CPS March: a-famrel
