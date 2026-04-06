*******************************************************************************
* Employer-provided health insurance coverage last year
*******************************************************************************
gen byte hiemply = .

if $marchcps == 1 {
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
		replace hiemply = 2 if cov_gh == 2
        replace hiemply = 1 if cov_gh == 1
	}
	if tm(2019m1) <= $date {
		replace hiemply = 0 if grp == 2
        replace hiemply = 1 if grp == 1
		replace hiemply = . if grp == 0
	}
}

lab var hiemply "Employer-provided health insurance coverage last year"
lab def hiemply 1 "Covered" 0 "Not covered"
lab val hiemply hiemply
notes hiemply: Available 1998-present
notes hiemply: 1998-2018 CPS: hiemp
notes hiemply: 2019-present CPS: grp
