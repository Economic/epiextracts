*******************************************************************************
* Medicaid, PCHIP, or other means-tested coverage last year
*******************************************************************************
gen byte himcaidly = .

if $marchcps == 1 {
	if tm(1980m1) <= $date {
		replace himcaidly = 1 if mcaid == 1
		replace himcaidly = 0 if mcaid == 2
	}
	if tm(1988m1) <= $date & $date <= tm(1994m12) {
		replace himcaidly = 1 if mcaid == 1 | chmc == 1
		replace himcaidly = 0 if mcaid == 2 & chmc == 2
	}
	if tm(1995m1) <= $date {
		replace himcaidly = 1 if mcaid == 1
		replace himcaidly = 0 if mcaid == 2
	}

}

lab var himcaidly "Medicaid coverage last year"
lab def himcaidly 1 "Covered" 0 "Not covered"
lab val himcaidly himcaidly
notes himcaidly: Available 1988-present
notes himcaidly: 1988-present universe: All persons (not infants born after calendar year)
notes himcaidly: 1988-1997 Unicon: mcaid
notes himcaidly: 1998-present CPS: mcaid
