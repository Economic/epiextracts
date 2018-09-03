*******************************************************************************
* Multiple job holder
*******************************************************************************
gen byte multjobs = .
if tm(1994m1) <= $date {
	replace multjobs = 0 if pemjot == 2
	replace multjobs = 1 if pemjot == 1
}
lab var multjobs "Multiple job holder"
lab def multjobs 1 "Has more than one job" 0 "Does not have more than one job"
lab val multjobs multjobs
notes multjobs: Only available 1994-present
notes multjobs: Universe = employed or unemployed
notes multjobs: 1994-present CPS: pemjot
