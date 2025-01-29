*******************************************************************************
* Weeks unemployed, looking and layoff
*******************************************************************************
gen int unempdur = .
lab var unempdur "Unemployment duration, in weeks"

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace unempdur = prunedur if prunedur >= 0 & prunedur ~= .
	}
}

if $marchcps == 1 {
	if tm(1968m1) <= $date & $date <= tm(1997m12) {
		replace unempdur = wksun
		replace unempdur = . if unempdur <= 0
	}
	if tm(1998m1) <= $date {
		replace unempdur = a_wkslk
		replace unempdur = . if unempdur <= 0
	}
}

notes unempdur: Only available since 1994
notes unempdur: Top-code inconsistent across time
notes unempdur: Top-code 1994-2011m3: 999; 2011m4-present: 119
notes unempdur: 1994-present CPS: prunedur
notes unempdur: 1968-1997 Unicon March: wksun
notes unempdur: 1998-present CPS March: a_wkslk
