*******************************************************************************
* Usual hours worked per week, earner study
*******************************************************************************
gen int hoursuorg = .
if $earnerinfo == 1 {
	if tm(1979m1) <= $date & $date <= tm(1993m12) {
		replace hoursuorg = ernush
	}
	if tm(1994m1) <= $date {
		replace hoursuorg = peernhro
	}
}
replace hoursuorg = . if hoursuorg < 0
lab var hoursuorg "Usual hours worked per week at this rate/job (earner study)"
lab def hoursuorg 99 "99+"
lab val hoursuorg hoursuorg
notes hoursuorg: Only available for the ORG sample
notes hoursuorg: Not a consistent universe over time
notes hoursuorg: Universe 1994-present: hourly workers
notes hoursuorg: Universe 1979-1993: hourly & nonhourly workers
notes hoursuorg: 1979-1993 Unicon: ernush
notes hoursuorg: 1994-present CPS: peernhro
