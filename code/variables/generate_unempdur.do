*******************************************************************************
* Weeks unemployed, looking and layoff
*******************************************************************************
gen int unempdur = .
lab var unempdur "Unemployment duration, in weeks"
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace unempdur = prunedur if prunedur >= 0 & prunedur ~= .
}
notes unempdur: Only available since 1994
notes unempdur: Top-code inconsistent across time
notes unempdur: Top-code 1994-2011m3: 999; 2011m4-present: 119
