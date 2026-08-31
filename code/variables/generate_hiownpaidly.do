*******************************************************************************
* Employer contribution to own employer-provided health insurance premium last year
*******************************************************************************
gen byte hiownpaidly = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1980m12) {
		replace hiownpaidly = 1 if hipaid == 1
        replace hiownpaidly = 0 if hipaid == 2
	}
	if tm(1981m1) <= $date & $date <= tm(1994m12) {
		* employer contributed some or all
		replace hiownpaidly = 1 if hipaid == 1 | hipaid == 2
        replace hiownpaidly = 0 if hipaid == 3
	}
	if tm(1995m1) <= $date & $date <= tm(1995m12) {
		* employer contributed some or all
		replace hiownpaidly = 1 if hipaid == 1
        replace hiownpaidly = 0 if hipaid == 2
	}
	if tm(1996m1) <= $date {
		* employer contributed some or all
		replace hiownpaidly = 1 if hipaid == 1 | hipaid == 2
        replace hiownpaidly = 0 if hipaid == 3
	}
}

lab var hiownpaidly "Employer contribution to own employer-provided health insurance premium last year"
lab def hiownpaidly 1 "Paid all or some of premium" 0 "Paid none of premium"
lab val hiownpaidly hiownpaidly
notes hiownpaidly: Available 1980-present
notes hiownpaidly: Universe: policyholders of employer/union-provided health insurance in their own name last year (hiownemply == 1)
notes hiownpaidly: 1980-present CPS: hipaid
