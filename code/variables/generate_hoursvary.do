*******************************************************************************
* Hours vary, primary job
*******************************************************************************
gen byte hoursvary = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hoursvary = 1 if pehrusl1 == -4
	}
}

lab var hoursvary "Usual hours vary, main job"
lab def hoursvary 0 "Hours do not vary" 1 "Hours vary"
lab val hoursvary hoursvary
notes hoursvary: Available 1994-present
notes hoursvary: 1994-present CPS: pehrusl1==-4
