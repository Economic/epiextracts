*******************************************************************************
* Detailed class of worker, job 1
*******************************************************************************
capture rename cow1 orig_cow1
gen byte cow1 = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace cow1 = peio1cow
		replace cow1 = . if peio1cow <= 0
	}
}

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(1993m12) {
		replace cow1 = 1 if class == 2
		replace cow1 = 2 if class == 3
		replace cow1 = 3 if class == 4
		replace cow1 = 6 if class == 5
		replace cow1 = 7 if class == 6
		replace cow1 = 8 if class == 7
		replace cow1 = 9 if class == 1

	}
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		replace cow1 = cowjob1
		replace cow1 = . if cowjob1 <= 0
	}
	if tm(1998m1) <= $date {
		replace cow1 = peio1cow
		replace cow1 = . if peio1cow <= 0
	}
}

lab var cow1 "Class of Worker, 1st job"
#delimit ;
lab def cow1
1 "Government - Federal"
2 "Government - State"
3 "Government - Local"
4 "Private, for profit"
5 "Private, nonprofit"
6 "Self-employed, incorporated"
7 "Self-employed, unincorporated"
8 "Without pay"
9 "Private"
;
#delimit cr
lab val cow1 cow1
notes cow1: Available 1994-present
notes cow1: 1994-1997 Unicon March: cowjob1
notes cow1: 1994/1998-present CPS Basic/March: peio1cow
