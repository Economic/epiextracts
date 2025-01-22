********************************************************************************
* Weekly earnings allocated by BLS
********************************************************************************
gen byte a_weekpay = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1979m1) <= $date & $date <= tm(1988m12) {
			replace a_weekpay = 0 if weekpay > 0 & weekpay ~= .
			replace a_weekpay = 1 if aernwk == 1 & weekpay > 0 & weekpay ~= .
			assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
		}
		if tm(1989m1) <= $date & $date <= tm(1993m12) {
			replace a_weekpay = 0 if weekpay > 0 & weekpay ~= .
			replace a_weekpay = 1 if aernwk >= 1 & aernwk <= 8 & weekpay > 0 & weekpay ~= .
			replace a_weekpay = 1 if ernwk ~= ernwkx & weekpay > 0 & weekpay ~= .
			assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
		}
		if tm(1995m9) <= $date {
			replace a_weekpay = 0 if weekpay > 0 & weekpay ~= .
			replace a_weekpay = 1 if prwernal == 1 & weekpay > 0 & weekpay ~= .
			assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
		}
	}
}

if $marchcps == 1 {
	if tm(1979m1) <= $date & $date <= tm(1997m12) {
		replace a_weekpay = 0 if weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if aernwk == 1 & weekpay > 0 & weekpay ~= .
		assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
	}
	if tm(1998m1) <= $date & $date <= tm(2000m12) {
		* Not available 1993–2000
	}
	if tm(2001m1) <= $date {
		replace a_weekpay = 0 if weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if prwernal == 1 & weekpay > 0 & weekpay ~= .
		assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
	}
}



lab var a_weekpay "Weekly pay allocated by BLS"
lab def a_weekpay 0 "Not allocated" 1 "Allocated"
lab val a_weekpay a_weekpay
notes a_weekpay: Allocation coding inconsistent across time
notes a_weekpay: Basic: No allocation codes available during 1994m1-1995m8
notes a_weekpay: March: No allocation codes available during 1993m1-2000m12
