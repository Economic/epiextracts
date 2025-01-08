*******************************************************************************
* Weeks unemployed looking, continuous
*******************************************************************************
gen int lookdur = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		replace lookdur = wksun if wksun >= 0 & wksun ~= .
	}
	if tm(1994m1) <= $date {
		replace lookdur = pelkdur if pelkdur >= 0 & pelkdur ~= .
	}
}

lab var lookdur "Job seeking duration (weeks)"
notes lookdur: Top-code inconsistent across time
notes lookdur: Top-code 1976-1993: 99; 1994-2011m3: 999; 2011m4-present: 119
notes lookdur: Definition/universe changes: 1973-1988, 1989-1993, 1994-present
notes lookdur: 1973-1993 Unicon: wksun
notes lookdur: 1994-present CPS: pelkdur
