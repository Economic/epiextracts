********************************************************************************
* Weekly earnings allocated by BLS
********************************************************************************
gen byte a_weekpay = .
if $earnerinfo == 1 {
	if tm(1979m1) <= $date & $date <= tm(1988m12) {
		replace a_weekpay = 0 if aernwk == . & weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if aernwk == 1 & weekpay > 0 & weekpay ~= .
		assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace a_weekpay = 0 if aernwk == 0 & weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if aernwk >= 1 & aernwk <= 8 & weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if ernwk ~= ernwkx
		assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
	}
	if tm(1995m9) <= $date & $date <= tm(2018m5) {
		replace a_weekpay = 0 if prwernal == 0 & weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if prwernal == 1 & weekpay > 0 & weekpay ~= .
		assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
	}
}

lab var a_weekpay "Weekly pay allocated by BLS"
lab def a_weekpay 0 "Not allocated" 1 "Allocated"
lab val a_weekpay a_weekpay
notes a_weekpay: Allocation coding inconsistent across time
notes a_weekpay: No allocation codes available during 1994m1-1995m8
