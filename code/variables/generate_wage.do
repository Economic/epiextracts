********************************************************************************
* wage
* NBER-style wage variable usual hourly earnings
* EXcluding overtime, tips, commissions for hourly workers
* adjusted for top-coding, hours vary imputations, and trimmed of extreme values
********************************************************************************

* first generate adjusted hourly earnings for non-paid-hourly
gen wage2_adjusted = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1973m1) <= $date & $date <= tm(1978m12) {
			replace wage2_adjusted = weekpay/hoursumay if paidhre == 0
		}
		if tm(1979m1) <= $date & $date <= tm(1993m12) {
			replace wage2_adjusted = weekpay/hoursuorg if paidhre == 0
		}
		if tm(1994m1) <= $date {
			replace wage2_adjusted = weekpay/hoursu1 if paidhre == 0
			* use imputed hours for hours vary respondents
			replace wage2_adjusted = weekpay/hoursu1i if paidhre == 0 & hoursvary == 1
		}
		replace wage2_adjusted = . if wage2_adjusted < 0
	}

	* now create top-code-adjusted and hours-adjusted wage variable
	capture confirm variable wage, exact
	if _rc == 0 {
		drop wage
	}
	gen wage = .
	if $earnerinfo == 1 {
		replace wage = wage_noadj if paidhre == 1
		replace wage = wage2_adjusted if paidhre == 0
	}
	drop wage2_adjusted

	* trim wage values according to extreme values
	merge m:1 year using $extremewages, assert(2 3) keepusing(wage_lower wage_upper)
	keep if _merge == 3
	replace wage = . if wage < wage_lower
	replace wage = . if wage > wage_upper
	drop _merge wage_lower wage_upper
}

lab var wage "Hourly wage (adjusted)"
notes wage: Dollars per hour, for hourly and nonhourly workers
notes wage: Approximates NBER's recommended wage variable
notes wage: Adjustments for weekly earnings top-coding, trimming of outliers
notes wage: Includes nonhourly workers whose usual hours vary
notes wage: Includes overtime, tips, commissions for nonhourly
notes wage: Excludes overtime, tips, commissions for hourly
