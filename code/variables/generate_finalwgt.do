********************************************************************************
* Final basic monthly weight
********************************************************************************
gen finalwgt = .

if $maycps == 1 {
	if tm(1998m1) <= $date {
		replace finalwgt = a_fnlwgt
	}
}

if $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace finalwgt = wgtfnl / 100
	}
}
if $monthlycps == 1 {
	if tm(1976m1) <= $date & $date <= tm(1993m12) {
		replace finalwgt = wgt / 100
	}
	if tm(1994m1) <= $date {
		replace finalwgt = pwsswgt
		* use Census 2000-based weights for 2000-2002
		if tm(2000m1) <= $date & $date <= tm(2002m12) {
			replace finalwgt = nwsswgt
		}
	}
}

replace finalwgt = . if finalwgt < 0
lab var finalwgt "Final basic monthly weight"
notes finalwgt: Sum to civilian, non-institutional population in each month
notes finalwgt: 1973-1981 Unicon May: wgtfnl
notes finalwgt: 1976-1993 Unicon: wgt
notes finalwgt: 1994-present CPS: pwsswgt
