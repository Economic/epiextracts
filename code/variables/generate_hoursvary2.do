*******************************************************************************
* Hours vary, other job
*******************************************************************************
gen byte hoursvary2 = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hoursvary2 = 0 if pehrusl2 >= 0 
		replace hoursvary2 = 1 if pehrusl2 == -4
	}
}

lab var hoursvary2 "Usual hours vary, other job"
lab def hoursvary2 0 "Hours do not vary" 1 "Hours vary"
lab val hoursvary2 hoursvary2
notes hoursvary2: Available 1994-present
notes hoursvary2: 1994-present CPS: pehrusl2==-4
