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
notes weekpay: Dollars per week for nonhourly and hourly workers
notes weekpay: Includes overtime, tips, commissions
notes weekpay: Top-code: 1973-85: 999; 1986-97: 1923; 1998-: 2884.61
notes weekpay: Some records in 1986-1988 may have earnings 999-1932
notes weekpay: 1973-1978 Unicon: wkusern
notes weekpay: 1979-1988 Unicon: ernwkc
notes weekpay: 1986-1988 Unicon, ernwk4x for ernwkc > 999
notes weekpay: 1989-1993 Unicon, ernwk
notes weekpay: 1994-present CPS: prernwa


********************************************************************************
* Weekly earnings top-coded
********************************************************************************
gen byte tc_weekpay = .
if $earnerinfo == 1 {
	replace tc_weekpay = 0 if weekpay >= 0 & weekpay ~= .
	if tm(1973m1) <= `date' & `date' <= tm(1985m12) {
		replace tc_weekpay = 1 if weekpay >= 999 & weekpay ~= .
	}
	if tm(1986m1) <= `date' & `date' <= tm(1997m12) {
		replace tc_weekpay = 1 if weekpay >= 1923 & weekpay ~= .
	}
	if tm(1986m1) <= `date' & `date' <= tm(2018m5) {
		replace tc_weekpay = 1 if weekpay >= 2884.61 & weekpay ~= .
	}
}
lab var tc_weekpay "Weekly pay top-coded by BLS"
lab def tc_weekpay 0 "Not top-coded" 1 "Top-coded"
lab val tc_weekpay tc_weekpay
notes tc_weekpay: Top-code for weekpay: 1973-85: 999; 1986-97: 1923; 1998-: 2884.61


********************************************************************************
* Weekly earnings allocated by BLS
********************************************************************************
gen byte a_weekpay = .
if $earnerinfo == 1 {
	if tm(1979m1) <= `date' & `date' <= tm(1988m12) {
		replace a_weekpay = 0 if aernwk == . & weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if aernwk == 1 & weekpay > 0 & weekpay ~= .
		assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
	}
	if tm(1989m1) <= `date' & `date' <= tm(1993m12) {
		replace a_weekpay = 0 if aernwk == 0 & weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if aernwk >= 1 & aernwk <= 8 & weekpay > 0 & weekpay ~= .
		replace a_weekpay = 1 if ernwk ~= ernwkx
		assert a_weekpay ~= . if weekpay > 0 & weekpay ~= .
	}
	if tm(1995m9) <= `date' & `date' <= tm(2018m5) {
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
		replace wage2 = weekpay/wkhrswk if paidhre == 0
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
notes wage2: 1973-1978, Unicon: weekpay/wkhrswk
notes wage2: 1979-1993, Unicon: weekpay/ernush
notes wage2: 1994-present, CPS: weekpay/pehrusl1


********************************************************************************
* wage
* NBER-style wage variable usual hourly earnings
* Including overtime, tips, commissions for nonhourly workers
* EXcluding overtime, tips, commissions for hourly workers
********************************************************************************
gen wage = wage1 if paidhre == 1
replace wage = wage2 if paidhre == 0
lab var wage "Hourly wage"
notes wage: Dollars per hour
notes wage: For hourly and nonhourly workers
notes wage: Approximates NBER's recommended wage variable
notes wage: Includes overtime, tips, commissions for nonhourly
notes wage: Excludes overtime, tips, commissions for hourly
notes wage: No adjustments for top-coding, no trimming of outliers
notes wage: Excludes nonhourly workers whose usual hours vary


********************************************************************************
* wageotc
* Usual hourly earnings including overtime, tips, commissions for
* hourly and nonhourly workers
********************************************************************************
gen wageotc = .
if $earnerinfo == 1 {
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
		* for hourly workers
		replace wageotc = wage1 if paidhre == 1
		replace wageotc = (weekpay/pehrusl1) if paidhre == 1 & wage1 < (weekpay/pehrusl1) & (weekpay/pehrusl1) ~= .
		replace wageotc = wage1 + (otcamt/peernhro) if paidhre == 1 & otcrec == 1 & 0 < otcamt & otcamt ~= . & 0 < peernhro & peernhro <= 99

		* for nonhourly
		replace wageotc = wage if paidhre==0
	}
}
replace wageotc = . if wageotc < 0
lab var wageotc "Hourly wage - OTC consistent"
notes wageotc: Dollars per hour
notes wageotc: For hourly and nonhourly workers
notes wageotc: Includes overtime, tips, commissions for nonhourly and hourly
notes wageotc: Covers only hourly workers who report hourly rate of pay
notes wageotc: No adjustments for top-coding, no trimming of outliers
notes wageotc: Excludes nonhourly workers whose usual hours vary
notes wageotc: 1994-present, CPS: derived from wage, weekpay, phersul1, otcamt, otrec, peernhro
