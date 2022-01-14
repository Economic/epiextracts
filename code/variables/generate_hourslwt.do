*******************************************************************************
* Hours worked last week, all jobs
*******************************************************************************
gen int hourslwt = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		replace hourslwt = hours
	}
	if tm(1994m1) <= $date {
		replace hourslwt = pehractt
	}
}

if $marchcps == 1 {
	if tm(1963m1) <= $date & $date <= tm(1967m12) {
		replace hourslwt = 0 if hours == 99
		replace hourslwt = hours if hours < 99
	}
	if tm(1968m1) <= $date & $date <= tm(1993m12) {
		replace hourslwt = hours
	}
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		replace hourslwt = hours 
	}
	if tm(1998m1) <= $date {
		replace hourslwt = a_hrs1
	}
}

replace hourslwt = . if hourslwt < 0

lab var hourslwt "Hours worked last week, total"
notes hourslwt: Universe/definition changes 1973-1988, 1989-1993, 1994-present
notes hourslwt: Top-coding inconsistent across time
notes hourslwt: Top-code 1973-1993: 99
notes hourslwt: Top-code 1994-present: 198
notes hourslwt: 1973-1993 May/Basic: hours
notes hourslwt: 1994-present May/Basic: pehractt
notes hourslwt: 1963-1997 March: hours
notes hourslwt: 1998-present March: a_hrs1
