********************************************************************************
* hoursuint: Usual hours worked weekly, intervalled
********************************************************************************
gen byte hoursuint = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		assert (1 <= prhrusl & prhrusl <= 8) | prhrusl == -1
		replace hoursuint = prhrusl
		replace hoursuint = . if hoursuint < 1
	}
}

label var hoursuint "Usual hours worked weekly, intervalled"
#delimit ;
lab def hoursuint
1 "0-20 hours"
2 "21-34 hours"
3 "35-39 hours"
4 "40 hours"
5 "41-49 hours"
6 "50 or more hours"
7 "Hours vary: full-time"
8 "Hours vary: part-time"
;
#delimit cr;
lab val hoursuint hoursuint
notes hoursuint: 1994-present CPS: prhrusl
