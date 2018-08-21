********************************************************************************
* Final basic monthly weight
********************************************************************************
gen finalwgt = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace finalwgt = wgtfnl / 100
	}
}
if $monthlycps == 1 & $maycps == 0 {
	if tm(1976m1) <= $date & $date <= tm(1993m12) {
		replace finalwgt = wgt / 100
	}
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace finalwgt = pwsswgt
}
replace finalwgt = . if finalwgt < 0
lab var finalwgt "Final basic monthly weight"
notes finalwgt: Sum to civilian, non-institutional population in each month
notes finalwgt: 1973-1981 Unicon May: wgtfnl
notes finalwgt: 1976-1993 Unicon: wgt
notes finalwgt: 1994-present CPS: pwsswgt
