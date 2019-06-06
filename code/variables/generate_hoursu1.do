*******************************************************************************
* Usual hours worked per week, primary job
*******************************************************************************
gen int hoursu1 = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hoursu1 = pehrusl1
	}
}

replace hoursu1 = . if hoursu1 < 0

lab var hoursu1 "Usual hours worked per week, main job"
lab def hoursu1 99 "99+"
lab val hoursu1 hoursu1
notes hoursu1: Only available 1994-present
notes hoursu1: 1994-present CPS: pehrusl1
