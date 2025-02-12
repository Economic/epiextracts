********************************************************************************
* Deaf or hearing difficulty
********************************************************************************
gen byte diffhear = .

if $monthlycps == 1 {
	if tm(2008m6) <= $date {
		replace diffhear = 0 if pedisear == 2
		replace diffhear = 1 if pedisear == 1
	}
}

label var diffhear "Hearing difficulty"
#delimit ;
lab def diffhear 
0 "Doesn't experience difficulty"  
1 "Experiences difficulty" 
;
#delimit cr
lab val diffhear diffhear
notes diffhear: 2008m6-present Basic: pedisear
