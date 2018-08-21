********************************************************************************
* Paid hourly
********************************************************************************
gen paidhre = .
if $earnerinfo == 1 {
	if tm(1973m1) <= $date & $date <= tm(1978m12) {
		replace paidhre = 1 if hourpd == 0
		replace paidhre = 0 if hourpd == 1
	}
	if tm(1979m1) <= $date & $date <= tm(1993m12) {
		replace paidhre = 0 if _ernpdh == 2
		replace paidhre = 1 if _ernpdh == 1
	}
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
		replace paidhre = 0 if peernhry == 2
		replace paidhre = 1 if peernhry == 1
	}
}
lab var paidhre "Paid by hour"
lab def paidhre 0 "Nonhourly worker" 1 "Hourly worker"
lab val paidhre paidhre
notes paidhre: Indicates respondent is paid by hour
notes paidhre: Only available in 1973-1978 May and 1979-present ORG
notes paidhre: 1973-1978 Unicon: hourpd
notes paidhre: 1979-1993 Unicon: _ernpdh
notes paidhre: 1994-present CPS: peernhry
