********************************************************************************
* Difficulty with disability status indicator
********************************************************************************
gen byte difficult = .

if $monthlycps == 1 {
	if tm(2008m1) <= $date {
		replace difficult = 0 if prdisflg == 2
		replace difficult = 1 if prdisflg == 1
	}
}

label var difficult "Difficulty indicator"
#delimit ;
lab def difficult 
0 "Doesn't not experience diffulty"
1 "Experiences difficulty"
#delimit cr ;
lab val difficult difficult
notes difficult: Derived from difficat
