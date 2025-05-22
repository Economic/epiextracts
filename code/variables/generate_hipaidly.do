*******************************************************************************
* Employer-paid health insurance last year
*******************************************************************************
capture label drop hipaid
capture rename hipaid orig_hipaid
gen byte hipaidly = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1980m12) {
		replace hipaidly = 0 if orig_hipaid == 2
		replace hipaidly = 3 if orig_hipaid == 1
	}    
	if tm(1981m1) <= $date & $date <= tm(1994m12) {
		replace hipaidly = 0 if orig_hipaid == 3
		replace hipaidly = 2 if orig_hipaid == 2
        replace hipaidly = 1 if orig_hipaid == 1
	}    
	if tm(1995m1) <= $date & $date <= tm(1995m12) {
		replace hipaidly = 0 if orig_hipaid == 2
		replace hipaidly = 3 if orig_hipaid == 1
	}   
	if tm(1996m1) <= $date {
		replace hipaidly = 0 if orig_hipaid == 3
		replace hipaidly = 2 if orig_hipaid == 2
        replace hipaidly = 1 if orig_hipaid == 1
	}
}

lab var hipaidly "Employer-paid health insurance last year"
lab def hipaidly 1 "Employer paid all premiums" 2 "Employer paid some premiums" 3 "Employer paid all or some premiums" 0 "Employer paid no premiums"
lab val hipaidly hipaidly
notes hipaidly: 1980-1997 Unicon: hipaid
notes hipaidly: 1998-present CPS: hipaid
