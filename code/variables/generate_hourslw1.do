*******************************************************************************
* Hours worked last week, primary job
*******************************************************************************
gen int hourslw1 = .
if tm(1994m1) <= $date {
	replace hourslw1 = pehract1
}
replace hourslw1 = . if hourslw1 < 0
lab var hourslw1 "Hours worked last week, main job"
lab def hourslw1 99 "99+"
lab val hourslw1 hourslw1
notes hourslw1: Only available 1994-present
notes hourslw1: 1994-present CPS: pehract1
