*******************************************************************************
* Hours vary, primary job
*******************************************************************************
gen byte hoursvary1 = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hoursvary1 = 0 if pehrusl1 >= 0 
		replace hoursvary1 = 1 if pehrusl1 == -4
	}
}

lab var hoursvary1 "Usual hours vary, main job"
lab def hoursvary1 0 "Hours do not vary" 1 "Hours vary"
lab val hoursvary1 hoursvary1
notes hoursvary1: Available 1994-present
notes hoursvary1: 1994-present CPS: pehrusl1==-4
