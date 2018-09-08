********************************************************************************
* wage
* NBER-style wage variable usual hourly earnings
* EXcluding overtime, tips, commissions for hourly workers
* adjusted for top-coding, hours vary imputations, and trimmed of extreme values
********************************************************************************

* first generate adjusted hourly earnings for non-paid-hourly
gen wage2_adjusted = .
if $earnerinfo == 1 {
	if tm(1973m1) <= $date & $date <= tm(1978m12) {
		replace wage2 = weekpay/hoursumay if paidhre == 0
	}
	if tm(1979m1) <= $date & $date <= tm(1993m12) {
		replace wage2 = weekpay/hoursuorg if paidhre == 0
	}
	if tm(1994m1) <= $date {
		replace wage2 = weekpay/hoursu1 if paidhre == 0
	}
	replace wage2_adjusted = . if wage2_adjusted < 0
}

* now create adjusted wage variable
gen wage = .
if $earnerinfo == 1 {
	replace wage = wage_noadj if paidhre == 1
	replace wage = wage2_adjusted if paidhre == 0
}

drop wage2_adjusted

lab var wage "Hourly wage (adjusted)"
notes wage: Dollars per hour, for hourly and nonhourly workers
notes wage: Approximates NBER's recommended wage variable
notes wage: Adjustments for weekly earnings top-coding, trimming of outliers
notes wage: Includes nonhourly workers whose usual hours vary
notes wage: Includes overtime, tips, commissions for nonhourly
notes wage: Excludes overtime, tips, commissions for hourly
