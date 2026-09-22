*******************************************************************************
* Private health insurance coverage last year
*******************************************************************************
gen byte hiprivly = .

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(1994m12) {
		replace hiprivly = 1 if covhi == 1
		replace hiprivly = 1 if chhi == 1 /* child private health insurance in HH */
		replace hiprivly = 1 if chhi == 2 /* child private health insurance outside HH */

	}
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace hiprivly = 1 if covhi == 1 
        replace hiprivly = 0 if covhi == 2

	}
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
		replace hiprivly = 3 if cov_hi == 1 
        replace hiprivly = 0 if cov_hi == 2

	}    
	if tm(2019m1) <= $date {
		replace hiprivly = 3 if priv == 1 
        replace hiprivly = 0 if priv == 2

	}
}

lab var hiprivly "Private health insurance coverage last year"
lab def hiprivly 1 "Covered" 0 "Not covered"
lab val hiprivly hiprivly
notes hiprivly: Available 1988-present
notes hiprivly: 1988-present universe: All persons (not infants born after calendar year)
notes hiprivly: 1988-1994 Unicon: covhi, chhhi
notes hiprivly: 1995-1997 Unicon: covhi
notes hiprivly: 1998-2018 CPS:cov_hi
notes hiprivly: 2019-present CPS: priv
