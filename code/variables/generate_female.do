********************************************************************************
* Gender
********************************************************************************
gen byte female = .

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1997m11) {
		replace female = 0 if sex == 1
		replace female = 1 if sex == 2
	}
	if tm(1998m1) <= $date {
		replace female = 0 if a_sex == 2
		replace female = 1 if a_sex == 1
	}
}

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		replace female = 0 if sex == 1
		replace female = 1 if sex == 2
	}
	if tm(1994m1) <= $date {
		replace female = 0 if pesex == 1
		replace female = 1 if pesex == 2
	}
}

lab var female "Female"
#delimit ;
lab define female
0 "Male"
1 "Female"
;
#delimit cr
lab val female female
notes female: 1976-1993 Unicon: sex
notes female: 1994-present CPS: pesex
