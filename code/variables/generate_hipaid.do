*******************************************************************************
* Employer/union helped pay for health insurance
*******************************************************************************
capture rename hipaid old_hipaid
gen byte hipaid = .

if $marchcps == 1 {
	if tm(1981m1) <= $date & $date <= tm(1994m12) {
        replace hipaid = 1 if old_hipaid == 2
        replace hipaid = 2 if old_hipaid == 1
        replace hipaid = 0 if old_hipaid == 3

	}
    if tm(1995m1) <= $date & $date <= tm(1995m12) {
        replace hipaid = 1 if old_hipaid == 1
        replace hipaid = 0 if old_hipaid == 2
    }
    if tm(1996m1) <= $date {
        replace hipaid = 1 if old_hipaid == 2
        replace hipaid = 2 if old_hipaid == 1
        replace hipaid = 0 if old_hipaid == 3
    }
}

lab var hipaid "Employer/union payed health insurance"
lab def hipaid 1 "Some health insurance paid" 2 "All health insurance paid" 0 "No health insurance paid", replace
lab val hipaid hipaid
notes hipaid: data from 1995 does not differentiate between partial and full employer payment
notes hipaid: 1981-1997 Unicon: hipaid
notes hipaid: 1997-present CPS: hipaid
