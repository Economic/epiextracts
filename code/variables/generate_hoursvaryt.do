*******************************************************************************
* Hours vary, all jobs
*******************************************************************************
gen byte hoursvaryt = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hoursvaryt = 0 if pehruslt >= 0 
		replace hoursvaryt = 1 if pehruslt == -4
	}
}

lab var hoursvaryt "Usual hours vary, other job"
lab def hoursvaryt 0 "Hours do not vary" 1 "Hours vary"
lab val hoursvaryt hoursvary2
notes hoursvaryt: Available 1994-present
notes hoursvaryt: 1994-present CPS: pehruslt==-4
