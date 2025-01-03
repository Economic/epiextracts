*******************************************************************************
* Employer-paid health insurance
*******************************************************************************
capture label drop hipaid
capture rename hipaid orig_hipaid
gen byte hipaid = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1980m12) {
		replace hipaid = 0 if orig_hipaid == 2
		replace hipaid = 3 if orig_hipaid == 1
	}    
	if tm(1981m1) <= $date & $date <= tm(1994m12) {
		replace hipaid = 0 if orig_hipaid == 3
		replace hipaid = 2 if orig_hipaid == 2
        replace hipaid = 1 if orig_hipaid == 1
	}    
	if tm(1995m1) <= $date & $date <= tm(1995m12) {
		replace hipaid = 0 if orig_hipaid == 2
		replace hipaid = 3 if orig_hipaid == 1
	}   
	if tm(1996m1) <= $date {
		replace hipaid = 0 if orig_hipaid == 3
		replace hipaid = 2 if orig_hipaid == 2
        replace hipaid = 1 if orig_hipaid == 1
	}
}

lab var hipaid "Employer-paid health insurance"
lab def hipaid 1 "Employer paid all premiums" 2 "Employer paid some premiums" 3 "Employer paid all or some premiums" 0 "Employer paid no premiums"
lab val hipaid hipaid
notes hipaid: 1980-1997 Unicon: hipaid
notes hipaid: 1998-present CPS: hipaid
