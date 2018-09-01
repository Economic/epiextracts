********************************************************************************
* wage_noadj
* NBER-style wage variable usual hourly earnings
* Including overtime, tips, commissions for nonhourly workers
* EXcluding overtime, tips, commissions for hourly workers
********************************************************************************

* first generate intermediate variables wage1 and wage2

* wage1
* Hourly earnings if "paid by hour" (paidhre==1)
gen wage1 = .
if $earnerinfo == 1 {
	if tm(1973m1) <= $date & $date <= tm(1978m12) {
		replace wage1 = hourern/100 if paidhre == 1
	}
	if tm(1979m1) <= $date & $date <= tm(1993m12) {
		* convert Unicon ernhr from pennies to dollars
		replace wage1 = ernhr/100 if paidhre == 1
	}
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
		* note that prernhly in Census ddf is in pennies (has implicit two decimal places) in the raw ascii files
		* but NBER data dictionaries account for this, so it is in dollars in the raw Stata files
		replace wage1 = prernhly if paidhre == 1
	}
}
replace wage1 = . if wage1 < 0
lab var wage1 "Hourly wage (if hourly worker)"
notes wage1: Dollars per hour
notes wage1: For hourly workers only; excludes overtime, tips, commissions
notes wage1: Top-code 1973-84: 99.99
notes wage1: Top-code 1985-2002, < 20 usual hours: 99.99
notes wage1: Top-code 1985-2002, 20+ usual hours: 1923.07/(usual hours)
notes wage1: Top-code 2003-present, < 29 usual hours: 99.99
notes wage1: Top-code 2003-present, 29+ usual hours: 2885.07/(usual hours)
notes wage1: 1973-1993 Unicon: hourern,ernhr if paidhre=1
notes wage1: 1994-present, CPS: prernhly if paidhre=1


* wage2
* Usual hourly earnings including overtime, tips, commissions
* nonhourly workers (paidhre==0)
gen wage2 = .
if $earnerinfo == 1 {
	if tm(1973m1) <= $date & $date <= tm(1978m12) {
		replace wage2 = weekpay_noadj/wkhrswk if paidhre == 0
	}
	if tm(1979m1) <= $date & $date <= tm(1993m12) {
		replace wage2 = weekpay_noadj/ernush if paidhre == 0
	}
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
		replace wage2 = weekpay_noadj/pehrusl1 if paidhre == 0
	}
}
replace wage2 = . if wage2 < 0
lab var wage2 "Hourly wage (for nonhourly worker)"
notes wage2: Dollars per hour
notes wage2: For nonhourly workers only
notes wage2: Includes overtime, tips, commissions
notes wage2: Usual weekly earnings / usual weekly hours
notes wage2: 1973-1978, Unicon: weekpay/wkhrswk
notes wage2: 1979-1993, Unicon: weekpay/ernush
notes wage2: 1994-present, CPS: weekpay/pehrusl1


* now generate wage variable
gen wage_noadj = wage1 if paidhre == 1
replace wage_noadj = wage2 if paidhre == 0
lab var wage_noadj "Hourly wage"
notes wage_noadj: Dollars per hour, for hourly & nonhourly workers
notes wage_noadj: Approximates NBER's recommended wage variable
notes wage_noadj: Includes overtime, tips, commissions for nonhourly
notes wage_noadj: Excludes overtime, tips, commissions for hourly
notes wage_noadj: No adjustments for top-coding, no trimming of outliers
notes wage_noadj: Excludes nonhourly workers whose usual hours vary
