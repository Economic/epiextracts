*******************************************************************************
* Hours worked last week, other jobs
*******************************************************************************
gen int hourslw2 = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hourslw2 = pehract2
	}
}

replace hourslw2 = . if hourslw2 < 0

lab var hourslw2 "Hours worked last week, other jobs"
lab def hourslw2 99 "99+"
lab val hourslw2 hourslw2
notes hourslw2: Only available 1994-present
notes hourslw2: 1994-present CPS: pehract2
