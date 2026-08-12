*******************************************************************************
* Policyholder of employer-provided health insurance last year
*******************************************************************************
gen byte hiemply = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(2018m12) {
		replace hiemply = 0 if orig_hiemp == 2
        replace hiemply = 1 if orig_hiemp == 1
	}
	if tm(2019m1) <= $date {
		replace hiemply = 0 if owngrp == 2
        replace hiemply = 1 if owngrp == 1
		replace hiemply = . if owngrp == 0
	}
}

lab var hiemply "Policyholder of employer-provided health insurance last year"
lab def hiemply 1 "Covered" 0 "Not covered"
lab val hiemply hiemply
notes hiemply: Available 1980-present
notes hiemply: 1998-2018 CPS: hiemp
notes hiemply: 2019-present CPS: owngrp
