********************************************************************************
* Difficulty walking or climbing stairs
********************************************************************************
gen byte diffphysical = .

if $monthlycps == 1 {
	if tm(2008m6) <= $date {
		replace diffphysical = 0 if pedisphy == 2
		replace diffphysical = 1 if pedisphy == 1
	}
}

label var diffphysical "Difficulty walking"
#delimit ;
lab def diffphysical 
0 "Doesn't experience difficulty"  
1 "Experiences difficulty" 
;
#delimit cr
lab val diffphysical diffphysical
notes diffphysical: 2008m6-present Basic: pedisphy
