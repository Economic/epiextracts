********************************************************************************
* Difficulty with disability status indicator
********************************************************************************
gen byte difficulty = .

if $monthlycps == 1 {
	if tm(2009m1) <= $date {
		replace difficulty = 0 if prdisflg == 2
		replace difficulty = 1 if prdisflg == 1
	}
}

label var difficulty "Difficulty indicator"
#delimit ;
lab def difficulty 
0 "Doesn't not experience any diffulty"
1 "Experiences one or more difficulty"
;
#delimit cr
lab val difficulty difficulty
notes difficult: 2008m6-present: prdisflg
