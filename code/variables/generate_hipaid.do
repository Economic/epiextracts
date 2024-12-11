*******************************************************************************
* Employer-paid health insurance
*******************************************************************************
capture rename hipaid orig_hipaid
gen byte hipaid = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1980m12) {
		replace hipaid = 0 if paidgh == 2
		replace hipaid = 3 if paidgh == 1
		replace hipaid = . if paidgh == 0
	}    
	if tm(1981m1) <= $date & $date <= tm(1988m12) {
		replace hipaid = 0 if paidgh == 3
		replace hipaid = 2 if paidgh == 2
        replace hipaid = 1 if paidgh == 1
		replace hipaid = . if paidgh == 0
	}    
	*check start and end months
	*1988 & 1988B have different underlying vars
	if tm(1989m1) <= $date & $date <= tm(1994m12) {
		replace hipaid = 0 if orig_hipaid == 3
		replace hipaid = 2 if orig_hipaid == 2
        replace hipaid = 1 if orig_hipaid == 1
		replace hipaid = . if orig_hipaid == 0
	}
	if tm(1995m1) <= $date & $date <= tm(1995m12) {
		replace hipaid = 0 if orig_hipaid == 2
		replace hipaid = 3 if orig_hipaid == 1
		replace hipaid = . if orig_hipaid == 0
	}   
	if tm(1996m1) <= $date {
		replace hipaid = 0 if orig_hipaid == 3
		replace hipaid = 2 if orig_hipaid == 2
        replace hipaid = 1 if orig_hipaid == 1
		replace hipaid = . if orig_hipaid == 0
	}
}

lab var hipaid "Employer-paid health insurance"
lab def hipaid 1 "Employer paid all premiums" 2 "Employer paid some premiums" 3 "Employer paid all or some premiums" 0 "Employer paid no premiums"
lab val hipaid hipaid
notes hipaid: Available 1980-present
notes hipaid: 1980-present universe: Included in employer group health plan
notes hipaid: 1980-1989 Unicon: paidgh
notes hipaid: 1989-1997 Unicon: hipaid
notes hipaid: 1998-present CPS: hipaid
