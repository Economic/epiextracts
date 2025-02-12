********************************************************************************
* Difficulty running errands alone
********************************************************************************
gen byte differrands = .

if $monthlycps == 1 {
	if tm(2008m6) <= $date {
		replace differrands = 0 if pedisout == 2
		replace differrands = 1 if pedisout == 1
	}
}

label var differrands "Difficulty doing errands"
#delimit ;
lab def differrands 
0 "Doesn't experience difficulty"  
1 "Experiences difficulty" 
;
#delimit cr
lab val differrands differrands
notes differrands: 2008m6-present Basic: pedisout
