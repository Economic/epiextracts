********************************************************************************
* Weekly earnings
********************************************************************************
gen weekpay = .
if $earnerinfo == 1 {
	if tm(1973m1) <= $date & $date <= tm(1978m12) {
		* weekly earnings in May CPS
		replace weekpay = wkusern
	}
	if tm(1979m1) <= $date & $date <= tm(1988m12) {
		* use computed weekly earnings
		replace weekpay = ernwkc

		* there is a higher top-code available in 1986-1988
		if tm(1986m1) <= $date & $date <= tm(1988m12) {
			replace weekpay = ernwk4x if (weekpay >= 999 & weekpay != . & ernwk4x > 999 & ernwk4x != .)
		}
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace weekpay = ernwk
	}
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
		* note that prernwa in Census ddf is in pennies (has implicit two decimal places) in the raw ascii files
		* but NBER data dictionaries account for this, so it is in dollars in the raw Stata files
		replace weekpay = prernwa
	}
}
replace weekpay = . if weekpay < 0
lab var weekpay "Weekly pay"
notes weekpay: Dollars per week for nonhourly and hourly workers
notes weekpay: Includes overtime, tips, commissions
notes weekpay: Top-code: 1973-85: 999; 1986-97: 1923; 1998-: 2884.61
notes weekpay: Some records in 1986-1988 may have earnings 999-1932
notes weekpay: 1973-1978 Unicon: wkusern
notes weekpay: 1979-1988 Unicon: ernwkc
notes weekpay: 1986-1988 Unicon, ernwk4x for ernwkc > 999
notes weekpay: 1989-1993 Unicon, ernwk
notes weekpay: 1994-present CPS: prernwa
