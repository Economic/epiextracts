********************************************************************************
* wageotc
* NBER-style wage variable usual hourly earnings
* INcluding overtime, tips, commissions for hourly workers
* adjusted for top-coding, hours vary imputations, and trimmed of extreme values
********************************************************************************

capture confirm variable wageotc, exact
if _rc == 0 {
	drop wageotc
}
gen wageotc = .

if $monthlycps == 1 {
	if $earnerinfo == 1 {
		if tm(1994m1) <= $date {
			* for hourly workers
			replace wageotc = wageotc_noadj if paidhre == 1
			* for nonhourly
			replace wageotc = wage if paidhre == 0
		}
	}

	* trim wage values according to extreme values
	merge m:1 year using $extremewages, assert(2 3) keepusing(wage_lower wage_upper)
	keep if _merge == 3
	replace wageotc = . if wageotc < wage_lower
	replace wageotc = . if wageotc > wage_upper
	drop _merge wage_lower wage_upper
}

lab var wageotc "Hourly wage (adjusted) - OTC consistent"
notes wageotc: Dollars per hour, for hourly and nonhourly workers
notes wageotc: Includes overtime, tips, commissions for nonhourly and hourly
notes wageotc: Adjustments for top-coding, trimming of outliers
notes wageotc: Includes nonhourly workers whose usual hours vary
notes wageotc: Covers only hourly workers who report hourly rate of pay
notes wageotc: 1994-present, CPS: derived from wage, weekpay, phersul1, otcamt, otrec, peernhro
