*******************************************************************************
* Usual hours worked per week, primary job
*******************************************************************************
gen int hoursu1 = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hoursu1 = pehrusl1
	}
}

if $marchcps == 1 {
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		replace hoursu1 = ernush
	}
	if tm(1998m1) <= $date {
		replace hoursu1 = a_uslhrs
	}
}

replace hoursu1 = . if hoursu1 < 0

lab var hoursu1 "Usual hours worked per week, main job"
lab def hoursu1 99 "99+"
lab val hoursu1 hoursu1
notes hoursu1: Only available 1994-present
notes hoursu1: 1994-present May/Basic: pehrusl1
notes hoursu1: 1994-1997 March: ernush
notes hoursu1: 1997-present March: a_uslhrs
