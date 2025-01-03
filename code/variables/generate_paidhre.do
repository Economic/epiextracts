********************************************************************************
* Paid hourly
********************************************************************************
gen paidhre = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1973m1) <= $date & $date <= tm(1978m12) {
			replace paidhre = 1 if hourpd == 0
			replace paidhre = 0 if hourpd == 1
		}
		if tm(1979m1) <= $date & $date <= tm(1993m12) {
			replace paidhre = 0 if _ernpdh == 2
			replace paidhre = 1 if _ernpdh == 1
		}
		if tm(1994m1) <= $date {
			replace paidhre = 0 if peernhry == 2
			replace paidhre = 1 if peernhry == 1
		}
	}
}

if $marchcps == 1 {
	if tm(1979m1) <= $date & $date <= tm(1997m12) {
		replace paidhre = 0 if ernpdh == 2
		replace paidhre = 1 if ernpdh == 1		
	}
	if tm(1998m1) <= $date {
		replace paidhre = 0 if a_hrlywk == 2
		replace paidhre = 1 if a_hrlywk == 1
	}
}

lab var paidhre "Paid by hour"
lab def paidhre 0 "Nonhourly worker" 1 "Hourly worker"
lab val paidhre paidhre
notes paidhre: Indicates respondent is paid by hour
notes paidhre: Only available in 1973-1978 May and 1979-present ORG
notes paidhre: 1973-1978 Unicon Basic: hourpd
notes paidhre: 1979-1993 Unicon Basic: _ernpdh
notes paidhre: 1994-present CPS Basic: peernhry
notes paidhre: 1979-1997 Unicon March: ernpdh
notes paidhre: 1998-present CPS March: a_hrlywk
