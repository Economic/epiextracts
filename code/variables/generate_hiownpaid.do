*******************************************************************************
* Employer contribution to own employer-provided health insurance premium
*******************************************************************************
gen byte hiownpaid = .

if $marchcps == 1 {
	if tm(2019m1) <= $date {
		* employer contributed some or all
		replace hiownpaid = 1 if now_hipaid == 1 | now_hipaid == 2
        replace hiownpaid = 0 if now_hipaid == 3
	}
}

lab var hiownpaid "Employer contribution to own employer-provided health insurance premium"
lab def hiownpaid 1 "Paid all or some of premium" 0 "Paid none of premium"
lab val hiownpaid hiownpaid
notes hiownpaid: Available 2019-present
notes hiownpaid: Universe: policyholders of employer/union-provided health insurance in their own name (hiownemp == 1)
notes hiownpaid: 2019-present CPS: hipaid
