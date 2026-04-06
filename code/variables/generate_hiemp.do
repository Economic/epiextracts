*******************************************************************************
* Employer-provided health insurance coverage
*******************************************************************************
capture lab drop hiemp
capture rename hiemp orig_hiemp

gen byte hiemp = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace hiemp = 0 if now_grp == 2
        replace hiemp = 1 if now_grp == 1
		replace hiemp = . if now_grp == 0
    }
}

lab var hiemp "Employer-provided health insurance coverage last year"
lab def hiemp 1 "Covered" 0 "Not covered"
lab val hiemp hiemp
notes hiemp: Available 2019-present
notes hiemp: 2019-present CPS: now_grp
