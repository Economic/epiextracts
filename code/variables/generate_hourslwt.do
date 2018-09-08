*******************************************************************************
* Hours worked last week, all jobs
*******************************************************************************
gen int hourslwt = .
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	replace hourslwt = hours
}
if tm(1994m1) <= $date {
	replace hourslwt = pehractt
}
replace hourslwt = . if hourslwt < 0
lab var hourslwt "Hours worked last week, total"
notes hourslwt: Universe/definition changes 1973-1988, 1989-1993, 1994-present
notes hourslwt: Top-coding inconsistent across time
notes hourslwt: Top-code 1973-1993: 99
notes hourslwt: Top-code 1994-present: 198
notes hourslwt: 1973-1993 Unicon: hours
notes hourslwt: 1994-present CPS: pehractt
