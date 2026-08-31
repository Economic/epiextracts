*******************************************************************************
* Policyholder of employer-provided health insurance
*******************************************************************************
gen byte hiownemp = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace hiownemp = 0 if now_owngrp == 2
        replace hiownemp = 1 if now_owngrp == 1
		replace hiownemp = . if now_owngrp == 0
    }
}

lab var hiownemp "Policyholder of employer-provided health insurance"
lab def hiownemp 1 "Policyholder" 0 "Not policyholder"
lab val hiownemp hiownemp
notes hiownemp: Available 2019-present
notes hiownemp: Universe: all persons with employment-based coverage
notes hiownemp: 2019-present CPS: now_grp
