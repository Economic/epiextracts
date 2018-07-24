local date = `1'

* does the current data contain earner information?
assert $earnerinfo == 1 | $earnerinfo == 0



********************************************************************************
* Weekly earnings
********************************************************************************
gen weekpay = .
if $earnerinfo == 1 {
	if tm(1973m1) <= `date' & `date' <= tm(1978m12) {
		* weekly earnings in May CPS
		replace weekpay = wkusern
	}
	if tm(1979m1) <= `date' & `date' <= tm(1988m12) {
		* use computed weekly earnings
		replace weekpay = ernwkc

		* there is a higher top-code available in 1986-1988
		if tm(1986m1) <= `date' & `date' <= tm(1988m12) {
			replace weekpay = ernwk4x if (weekpay >= 999 & weekpay != . & ernwk4x > 999 & ernwk4x != .)
		}
	}
	if tm(1989m1) <= `date' & `date' <= tm(1993m12) {
		* use computed weekly earnings
		replace weekpay = ernwk
	}
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
		* note that prernwa in Census ddf is in pennies (has implicit two decimal places) in the raw ascii files
		* but NBER data dictionaries account for this, so it is in dollars in the raw Stata files
		replace weekpay = prernwa
	}
}
replace weekpay = . if weekpay < 0
lab var weekpay "Weekly pay"
notes weekpay: Dollars per week
notes weekpay: For nonhourly and hourly workers
notes weekpay: Includes overtime, tips, commissions
notes weekpay: Top-code: 1973-85: 999; 1986-97: 1923; 1998-: 2884
notes weekpay: Some records in 1986-1988 may have earnings 999-1932
notes weekpay: 1973-1978 Unicon: wkusern
notes weekpay: 1979-1988 Unicon: ernwkc
notes weekpay: 1986-1988 Unicon, ernwk4x for ernwkc > 999
notes weekpay: 1989-1993 Unicon, ernwk
notes weekpay: 1994-present CPS: prernwa



********************************************************************************
* Paid hourly
********************************************************************************
gen paidhre = .
if $earnerinfo == 1 {
	if tm(1973m1) <= `date' & `date' <= tm(1978m12) {
		replace paidhre = 1 if hourpd == 0
		replace paidhre = 0 if hourpd == 1
	}
	if tm(1979m1) <= `date' & `date' <= tm(1993m12) {
		replace paidhre = 0 if _ernpdh == 2
		replace paidhre = 1 if _ernpdh == 1
	}
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
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



********************************************************************************
* Usually receive overtime, tips, commissions 1994-; hourly only
********************************************************************************
* it looks possible to extend the overtime definitions past hourly workers
gen byte otcrec = .
if $earnerinfo == 1 {
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
		replace otcrec = 0 if paidhre == 1 & peernuot == 2
		replace otcrec = 1 if paidhre == 1 & peernuot == 1
	}
}
lab var otcrec "Usually receive overtime, tips, commissions"
notes otcrec: Hourly workers only
notes otcrec: 1994-present CPS: derived from peernuot & paidhre



********************************************************************************
* Weekly earnings from overtime, tips, commissions 1994-
********************************************************************************
gen byte otcamt=.
if $earnerinfo == 1 {
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
		replace otcamt = peern/100 if paidhre == 1 & otcrec == 1
	}
}
replace otcamt = . if otcamt < 0
lab var otcamt "Weekly earnings overtime, tips, commissions"
notes otcamt: Hourly workers only
notes otcamt: 1994-present, CPS: derived from peern, otcrec



********************************************************************************
* wage1
* Hourly earnings if "paid by hour" (paidhre==1)
********************************************************************************
gen wage1 = .
if $earnerinfo == 1 {
	if tm(1973m1) <= `date' & `date' <= tm(1978m12) {
		replace wage1 = hourern/100 if paidhre == 1
	}
	if tm(1979m1) <= `date' & `date' <= tm(1993m12) {
		* convert Unicon ernhr from pennies to dollars
		replace wage1 = ernhr/100 if paidhre == 1
	}
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
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



********************************************************************************
* wage2
* Usual hourly earnings including overtime, tips, commissions
* nonhourly workers (paidhre==0)
********************************************************************************
gen wage2 = .
if $earnerinfo == 1 {
	if tm(1973m1) <= `date' & `date' <= tm(1978m12) {
		replace wage2 = weekpay/hours if paidhre == 0
	}
	if tm(1979m1) <= `date' & `date' <= tm(1993m12) {
		replace wage2 = weekpay/ernush if paidhre == 0
	}
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
		replace wage2 = weekpay/pehrusl1 if paidhre == 0
	}
}
replace wage2 = . if wage2 < 0
lab var wage2 "Hourly wage (for nonhourly worker)"
notes wage2: Dollars per hour
notes wage2: For nonhourly workers only
notes wage2: Includes overtime, tips, commissions
notes wage2: Usual weekly earnings / usual weekly hours
notes wage2: 1979-1993, Unicon: weekpay/ernush
notes wage2: 1994-present, CPS: weekpay/pehrusl1



********************************************************************************
* wage3
* NBER-style wage variable usual hourly earnings
* Including overtime, tips, commissions for nonhourly workers
* EXcluding overtime, tips, commissions for hourly workers
********************************************************************************
gen wage3 = wage1 if paidhre == 1
replace wage3 = wage2 if paidhre == 0
lab var wage3 "Hourly wage"
notes wage3: Dollars per hour
notes wage3: For hourly and nonhourly workers
notes wage3: Approximates NBER's recommended wage variable
notes wage3: Includes overtime, tips, commissions for nonhourly
notes wage3: Excludes overtime, tips, commissions for hourly
notes wage3: No adjustments for top-coding, no trimming of outliers
notes wage3: Excludes nonhourly workers whose usual hours vary



********************************************************************************
* wage4
* Usual hourly earnings including overtime, tips, commissions for
* hourly and nonhourly workers
********************************************************************************
gen wage4 = .
if $earnerinfo == 1 {
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
		* for hourly workers
		replace wage4 = wage1 if paidhre == 1
		replace wage4 = (weekpay/pehrusl1) if paidhre == 1 & wage1 < (weekpay/pehrusl1) & (weekpay/pehrusl1) ~= .
		replace wage4= wage1 + (otcamt/peernhro) if paidhre==1 & otcrec==1 & 0<otcamt & otcamt~=. & 0<peernhro & peernhro<=99

		* for nonhourly
		replace wage4 = wage3 if paidhre==0
	}
}
replace wage4 = . if wage4 < 0
lab var wage4 "Hourly wage"
notes wage4: Dollars per hour
notes wage4: For hourly and nonhourly workers
notes wage4: Includes overtime, tips, commissions for nonhourly and hourly
notes wage4: Covers only hourly workers who report hourly rate of pay
notes wage4: No adjustments for top-coding, no trimming of outliers
notes wage4: Excludes nonhourly workers whose usual hours vary
notes wage4: 1994-present, CPS: derived from wage1, weekpay, phersul1, otcamt, otrec, peernhro
