*******************************************************************************
* Detailed class of worker, job 2
*******************************************************************************
gen byte cow2 = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace cow2 = peio2cow
		replace cow2 = . if peio2cow <= 0
	}
}

lab var cow2 "Class of Worker, 2nd job"
#delimit ;
lab def cow2
1 "Government - Federal"
2 "Government - State"
3 "Government - Local"
4 "Private, for profit"
5 "Private, nonprofit"
6 "Self-employed, incorporated"
7 "Self-employed, unincorporated"
8 "Without pay"
;
#delimit cr
lab val cow2 cow2
notes cow2: Available 1994-present
notes cow2: 1994-present CPS: peio2cow
