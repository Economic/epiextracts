********************************************************************************
* Difficulty with disability status category
********************************************************************************
gen byte difficat = .

if $monthlycps == 1 {
	if tm(2008m1) <= $date {
		replace difficat = 0 if prdisflg == 2
		replace difficat = 1 if pediseye == 1
		replace difficat = 2 if pedisear == 1
		replace difficat = 3 if pedisrem == 1
		replace difficat = 4 if pedisphy == 1
		replace difficat = 5 if pedisdrs == 1
		replace difficat = 6 if pedisout == 1
	}
}

label var difficat "Difficulty category"
#delimit ;
lab def difficat 
0 "No difficulty" 
1 "Hearing difficulty" 
2 "Vision difficulty" 
3 "Mental difficulty" 
4 "Physical difficulty" 
5 "Dressing difficulty" 
6 "Navigating difficulty"
#delimit cr ;
lab val difficat difficat
notes difficat: 2008-present Basic: prdisflg, pedis*
