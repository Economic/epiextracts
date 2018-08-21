********************************************************************************
* wageotc
* Usual hourly earnings including overtime, tips, commissions for
* hourly and nonhourly workers
********************************************************************************
gen wageotc = .
if $earnerinfo == 1 {
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
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
