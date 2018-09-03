********************************************************************************
* wageotc_noadj
* Usual hourly earnings including overtime, tips, commissions for
* hourly and nonhourly workers
********************************************************************************
gen wageotc_noadj = .
if $earnerinfo == 1 {
	if tm(1994m1) <= $date {
		* for hourly workers
		replace wageotc_noadj = earnhour if paidhre == 1
		replace wageotc_noadj = (weekpay_noadj/pehrusl1) if paidhre == 1 & earnhour < (weekpay_noadj/pehrusl1) & (weekpay/pehrusl1) ~= .
		replace wageotc_noadj = earnhour + (otcamt/peernhro) if paidhre == 1 & otcrec == 1 & 0 < otcamt & otcamt ~= . & 0 < peernhro & peernhro <= 99

		* for nonhourly
		replace wageotc_noadj = wage_noadj if paidhre == 0
	}
}
replace wageotc_noadj = . if wageotc_noadj < 0
lab var wageotc_noadj "Hourly wage - OTC consistent"
notes wageotc_noadj: Dollars per hour, for hourly and nonhourly workers
notes wageotc_noadj: Includes overtime, tips, commissions for nonhourly and hourly
notes wageotc_noadj: Covers only hourly workers who report hourly rate of pay
notes wageotc_noadj: No adjustments for top-coding, no trimming of outliers
notes wageotc_noadj: Excludes nonhourly workers whose usual hours vary
notes wageotc_noadj: 1994-present, CPS: derived from wage_noadj, weekpay_noadj, phersul1, otcamt, otrec, peernhro
