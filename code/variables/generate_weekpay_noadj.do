********************************************************************************
* Weekly earnings
********************************************************************************
gen weekpay_noadj = .
if $earnerinfo == 1 {
	if tm(1973m1) <= $date & $date <= tm(1978m12) {
		* weekly earnings in May CPS
		replace weekpay_noadj = wkusern
	}
	if tm(1979m1) <= $date & $date <= tm(1988m12) {
		* use computed weekly earnings
		replace weekpay_noadj = ernwkc

		* there is a higher top-code available in 1986-1988
		if tm(1986m1) <= $date & $date <= tm(1988m12) {
			replace weekpay_noadj = ernwk4x if (weekpay_noadj >= 999 & weekpay_noadj != . & ernwk4x > 999 & ernwk4x != .)
		}
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace weekpay_noadj = ernwk
	}
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
		* note that prernwa in Census ddf is in pennies (has implicit two decimal places) in the raw ascii files
		* but NBER data dictionaries account for this, so it is in dollars in the raw Stata files
		replace weekpay_noadj = prernwa
	}
}


if $monthlycps == 0 & $maycps == 1 & tm(1980m1) <= $date & $date <= tm(1980m12) {
	* there seems to be something wrong with ernwk and ernwkc in 1980 may data
	* moving to missing for now
	replace weekpay_noadj = .
}


replace weekpay_noadj = . if weekpay_noadj < 0
lab var weekpay_noadj "Weekly pay"
notes weekpay_noadj: Dollars per week for nonhourly and hourly workers
notes weekpay_noadj: Includes overtime, tips, commissions
notes weekpay_noadj: Top-code: 1973-85: 999; 1986-97: 1923; 1998-: 2884.61
notes weekpay_noadj: Some records in 1986-1988 may have earnings 999-1932
notes weekpay_noadj: 1973-1978 Unicon: wkusern
notes weekpay_noadj: 1979-1988 Unicon: ernwkc
notes weekpay_noadj: 1986-1988 Unicon, ernwk4x for ernwkc > 999
notes weekpay_noadj: 1989-1993 Unicon, ernwk
notes weekpay_noadj: 1994-present CPS: prernwa
