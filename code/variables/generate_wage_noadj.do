********************************************************************************
* wage_noadj
* NBER-style wage variable usual hourly earnings
* Including overtime, tips, commissions for nonhourly workers
* EXcluding overtime, tips, commissions for hourly workers
********************************************************************************

* wage2
* Usual hourly earnings including overtime, tips, commissions
* nonhourly workers (paidhre==0)
gen wage2 = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1973m1) <= $date & $date <= tm(1978m12) {
			replace wage2 = weekpay_noadj/hoursumay if paidhre == 0
		}
		if tm(1979m1) <= $date & $date <= tm(1993m12) {
			replace wage2 = weekpay_noadj/hoursuorg if paidhre == 0
		}
		if tm(1994m1) <= $date {
			replace wage2 = weekpay_noadj/hoursu1 if paidhre == 0
		}
	}
}

replace wage2 = . if wage2 < 0

lab var wage2 "Hourly wage (for nonhourly worker)"
notes wage2: Dollars per hour
notes wage2: For nonhourly workers only
notes wage2: Includes overtime, tips, commissions
notes wage2: Usual weekly earnings / usual weekly hours
notes wage2: 1973-1978: weekpay_noadj/hoursumay
notes wage2: 1979-1993: weekpay_noadj/hoursuorg
notes wage2: 1994-present: weekpay_noadj/hoursu1

* now generate wage variable
gen wage_noadj = earnhour if paidhre == 1
replace wage_noadj = wage2 if paidhre == 0

if $maycps == 1 & tm(1980m1) <= $date & $date <= tm(1980m12) {
	* there seems to be something wrong with weekpay in 1980 may data
	* for now in these data code this variable to missing
	replace wage_noadj = .
}

lab var wage_noadj "Hourly wage"
notes wage_noadj: Dollars per hour, for hourly & nonhourly workers
notes wage_noadj: Approximates NBER's recommended wage variable
notes wage_noadj: Includes overtime, tips, commissions for nonhourly
notes wage_noadj: Excludes overtime, tips, commissions for hourly
notes wage_noadj: No adjustments for top-coding, no trimming of outliers
notes wage_noadj: Excludes nonhourly workers whose usual hours vary
