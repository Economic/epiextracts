*******************************************************************************
* Usual hours worked per week, all jobs
*******************************************************************************
gen int hoursut = .
if tm(1994m1) <= $date {
	replace hoursut = pehruslt
}
replace hoursut = . if hoursut < 0
lab var hoursut "Usual hours worked per week, all jobs"
lab def hoursut 198 "198+"
lab val hoursut hoursut
notes hoursut: Only available 1994-present
notes hoursut: 1994-present CPS: pehruslt
