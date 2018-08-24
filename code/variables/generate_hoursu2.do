*******************************************************************************
* Usual hours worked per week, other jobs
*******************************************************************************
gen int hoursu2 = .
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace hoursu2 = pehrusl2
}
replace hoursu2 = . if hoursu2 < 0
lab var hoursu2 "Usual hours worked per week, main job"
lab def hoursu2 99 "99+"
lab val hoursu2 hoursu2
notes hoursu2: Only available 1994-present
notes hoursu2: 1994-present CPS: pehrusl2