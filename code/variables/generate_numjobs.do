*******************************************************************************
* Number of jobs
*******************************************************************************
gen byte numjobs = .
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace numjobs = 1 if emp == 1
	replace numjobs = 2 if pemjnum == 2
	replace numjobs = 3 if pemjnum == 3
	replace numjobs = 4 if pemjnum == 4
}
lab var numjobs "Number of jobs"
lab def numjobs 1 "Employed with one job" 2 "Two jobs" 3 "Three jobs" 4 "Four or more jobs"
lab val numjobs numjobs
notes numjobs: Only available 1994-present
notes numjobs: Universe = employed for one job, labor force for 2+ numjobs
notes numjobs: Top-code: 4 = four or more jobs
notes numjobs: 1994-present CPS: pemjnum
