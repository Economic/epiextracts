********************************************************************************
* Blind or difficulty with vision
********************************************************************************
gen byte diffvision = .

if $monthlycps == 1 {
	if tm(2009m1) <= $date {
		replace diffvision = 0 if pediseye == 2
		replace diffvision = 1 if pediseye == 1
	}
}

label var diffvision "Difficulty with vision"
#delimit ;
lab def diffvision 
0 "Doesn't experience difficulty"
1 "Experiences difficulty"
;
#delimit cr
lab val diffvision diffvision
notes diffvision: 2008m6-present Basic: pediseye
