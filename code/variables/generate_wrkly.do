*******************************************************************************
* Worked any time last year, including temporary and part-time
*******************************************************************************
gen byte wrkly = .

if $marchcps == 1 {
    *check starting year (1988B or 1989?)
	if tm(1989m1) <= $date & $date <= tm(1997m12) {
        *check name, is it wrk_ck?
		replace wrkly = 0 if chkwrk == 2
        replace wrkly = 1 if chkwrk == 1
		replace wrkly = . if chkwrk == 0
	}    
	if tm(1998m1) <= $date {
		replace wrkly = 0 if wrk_ck == 2
        replace wrkly = 1 if wrk_ck == 1
		replace wrkly = . if wrk_ck == 0
	} 
}

lab var wrkly "Worked any time last year"
lab def wrkly 1 "Worked last year " 0 "Didn't work last year"
lab val wrkly wrkly
notes wrkly: Available 1989-present
notes wrkly: 1988-present universe: age 15+
notes wrkly: 1989-1997 Unicon: chkwrk
notes wrkly: 1998-2018 CPS: hiemp
notes wrkly: 2019-present CPS: owngrp
