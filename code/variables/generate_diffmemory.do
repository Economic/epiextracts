********************************************************************************
* Difficulty with remembering, concentrating, or making decisions
********************************************************************************
gen byte diffmemory = .

if $monthlycps == 1 {
	if tm(2009m1) <= $date {
		replace diffmemory = 0 if pedisrem == 2
		replace diffmemory = 1 if pedisrem == 1
	}
}

label var diffmemory "Difficulty with memory"
#delimit ;
lab def diffmemory 
0 "Doesn't experience difficulty"  
1 "Experiences difficulty" 
;
#delimit cr
lab val diffmemory diffmemory
notes diffmemory: 2008m6-present Basic: pedisrem
