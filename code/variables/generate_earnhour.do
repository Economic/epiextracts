********************************************************************************
* earnhour
* Hourly earnings, for those paid by the hour
* EXcludes overtime, tips, commissions
********************************************************************************
gen earnhour = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1973m1) <= $date & $date <= tm(1978m12) {
			replace earnhour = hourern/100
		}
		if tm(1979m1) <= $date & $date <= tm(1993m12) {
			* convert Unicon ernhr from pennies to dollars
			replace earnhour = ernhr/100
		}
		if tm(1994m1) <= $date {
			* note that prernhly in Census ddf is in pennies (has implicit two decimal places) in the raw ascii files
			* but NBER data dictionaries account for this, so it is in dollars in the raw Stata files
			replace earnhour = prernhly
		}
	}
replace earnhour = . if earnhour < 0
}

lab var earnhour "Hourly wage (if hourly worker)"
notes earnhour: Dollars per hour
notes earnhour: For hourly workers only; excludes overtime, tips, commissions
notes earnhour: Top-code 1973-84: 99.99
notes earnhour: Top-code 1985-2002, < 20 usual hours: 99.99
notes earnhour: Top-code 1985-2002, 20+ usual hours: 1923.07/(usual hours)
notes earnhour: Top-code 2003-present, < 29 usual hours: 99.99
notes earnhour: Top-code 2003-present, 29+ usual hours: 2885.07/(usual hours)
notes earnhour: 1973-1993 Unicon: hourern,ernhr
notes earnhour: 1994-present CPS: prernhly
