*******************************************************************************
* Same job as last month
*******************************************************************************
gen byte samejob = .
if tm(1994m1) <= $date {
	replace samejob = 1 if puiodp1 == 1
	replace samejob = 0 if puiodp1 == 2
}
lab var samejob "Same employer as last month, at main job"
lab def samejob 1 "Same employer" 0 "Not the same employer"
lab val samejob samejob
notes samejob: Available 1994-present
notes samejob: 1994-present CPS: puiodp1
