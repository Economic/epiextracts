*******************************************************************************
* Usual hours worked per week, earner study
*******************************************************************************
gen int hoursuorg = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1979m1) <= $date & $date <= tm(1993m12) {
			replace hoursuorg = ernush
		}
		if tm(1994m1) <= $date {
			* start with ORG hours variable, only defined for some hourly workers
			replace hoursuorg = peernhro
			* use basic usual hours if missing
			replace hoursuorg = hoursu1 if (peernhro == . | peernhro <= 0) & (minsamp == 4 | minsamp == 8)
		}
	}
}

if $march == 1 {
	if tm(1979m1) <= $date & $date <= tm(1994m12) {
		replace hoursuorg = ernush
	}
	if ernel == 1 {
		* ORG hours variable only defined for some hourly workers
		if tm(1995m1) <= $date & $date <= tm(1997m12) {
			replace hoursuorg = ernush
		}
	}
	else {
		replace hoursuorg = .
	}
	if preregl == 1 {
		if tm(1998m1) <= $date {
			replace hoursuorg = a_uslhrs
		}
	}
	else {
		replace hoursuorg = .
	}
}

replace hoursuorg = . if hoursuorg < 0
lab var hoursuorg "Usual hours worked per week at this rate/job (earner study)"
lab def hoursuorg 99 "99+"
lab val hoursuorg hoursuorg
notes hoursuorg: Only available for the ORG sample
notes hoursuorg: Definition break in 1994
notes hoursuorg: 1979-1993 May/Basic: ernush
notes hoursuorg: 1994-present May/Basic: peernhro and hoursu1
notes hoursuorg: 1979-1997 March: ernush
notes hoursuorg: 1998-present a_uslhrs
