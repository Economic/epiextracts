*******************************************************************************
* Private health insurance coverage last year
*******************************************************************************
gen byte hiprivly = .

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(1994m12) {
		replace hiprivly = 1 if covhi == 1
		replace hiprivly = 1 if chhi == 1 /* child private health insurance in HH */
		replace hiprivly = 1 if chhi == 2 /* child private health insurance outside HH */
		replace hiprivly = 0 if covhi == 2 | chhi == 3

	}
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace hiprivly = 1 if covhi == 1 
        replace hiprivly = 0 if covhi == 2

	}
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
		replace hiprivly = 1 if cov_hi == 1
        replace hiprivly = 0 if cov_hi == 2

		* 1998-1999: Census June 2007 revision flags for whole-household plans
		if $date <= tm(1999m12) {
			replace hiprivly = 1 if allempl == 1 | allpriv == 1
		}
	}
	if tm(2019m1) <= $date {
		replace hiprivly = 1 if priv == 1
        replace hiprivly = 0 if priv == 2

	}
}

lab var hiprivly "Private health insurance coverage last year"
lab def hiprivly 1 "Covered" 0 "Not covered"
lab val hiprivly hiprivly
notes hiprivly: Available 1988-present
notes hiprivly: 1988-present universe: All persons (not infants born after calendar year)
notes hiprivly: 1988-1994 Unicon: covhi, chhi
notes hiprivly: 1995-1997 Unicon: covhi
notes hiprivly: 1998-2018 CPS: cov_hi
notes hiprivly: 1998-1999 CPS: adds allempl, allpriv from Census June 2007 health insurance revision
notes hiprivly: 2000-2010 CPS: recodes from Census September 2011 health insurance revision
notes hiprivly: 2019-present CPS: priv
