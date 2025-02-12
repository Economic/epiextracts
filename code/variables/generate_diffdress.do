********************************************************************************
* Difficulty dressing or bathing
********************************************************************************
gen byte diffdress = .

if $monthlycps == 1 {
	if tm(2008m6) <= $date {
		replace diffdress = 0 if pedisdrs == 2
		replace diffdress = 1 if pedisdrs == 1
	}
}

label var diffdress "Difficulty dressing"
#delimit ;
lab def diffdress 
0 "Doesn't experience difficulty"  
1 "Experiences difficulty" 
;
#delimit cr
lab val diffdress diffdress
notes diffdress: 2008m6-present Basic: prdisflg, pedis*
