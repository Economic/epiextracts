*******************************************************************************
* Hours vary, primary job
*******************************************************************************
gen byte hoursvary = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hoursvary = 0 if pehrusl1 >= 0 
		replace hoursvary = 1 if pehrusl1 == -4
	}
}
if $marchcps == 1 {
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		replace hoursvary = 0 if ernush >= 0 
		replace hoursvary = 1 if ernush == -4
	}
	if tm(1998m1) <= $date {
		replace hoursvary = 0 if a_uslhrs >= 0 
		replace hoursvary = 1 if a_uslhrs == -4
	}
}

lab var hoursvary "Usual hours vary, main job"
lab def hoursvary 0 "Hours do not vary" 1 "Hours vary"
lab val hoursvary hoursvary
notes hoursvary: Available 1994-present
notes hoursvary: 1994-present CPS Basic: pehrusl1==-4
notes hoursvary: 1994-1997 Unicon March: ernush==-4
notes hoursvary: 1998-present CPS Basic: a_uslhrs==-4

