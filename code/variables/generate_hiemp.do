*******************************************************************************
* Policyholder of employer-provided health insurance
*******************************************************************************
capture lab drop hiemp
capture rename hiemp orig_hiemp

gen byte hiemp = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace hiemp = 0 if now_owngrp == 2
        replace hiemp = 1 if now_owngrp == 1
		replace hiemp = . if now_owngrp == 0
    }
}

lab var hiemp "Policyholder of employer-provided health insurance"
lab def hiemp 1 "Covered" 0 "Not covered"
lab val hiemp hiemp
notes hiemp: Available 2019-present
notes hiemp: 2019-present CPS: now_grp
