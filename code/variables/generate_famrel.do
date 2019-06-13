*******************************************************************************
* Family relationship recode
*******************************************************************************
cap drop famrel
cap lab drop famrel
gen byte famrel = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace famrel = prfamrel if prfamrel >= 0
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
notes famrel: 1994-present CPS: prfamrel
