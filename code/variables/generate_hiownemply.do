*******************************************************************************
* Policyholder of employer-provided health insurance last year
*******************************************************************************
gen byte hiownemply = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(2018m12) {
		replace hiownemply = 0 if hiemp == 2
        replace hiownemply = 1 if hiemp == 1
	}
	if tm(2019m1) <= $date {
		replace hiownemply = 0 if owngrp == 2
        replace hiownemply = 1 if owngrp == 1
		replace hiownemply = . if owngrp == 0
	}
}

lab var hiownemply "Policyholder of employer-provided health insurance last year"
lab def hiownemply 1 "Covered" 0 "Not covered"
lab val hiownemply hiownemply
notes hiownemply: Available 1980-present
notes hiownemply: Universe 1998-2018: those who worked last year
notes hiownemply: Universe 2019-present: all persons with employment-based coverage
notes hiownemply: 1998-2018 CPS: hiemp
notes hiownemply: 2019-present CPS: owngrp
