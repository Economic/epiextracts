*******************************************************************************
* Usual hours worked per week, all jobs
*******************************************************************************
gen int hoursut = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace hoursut = pehruslt
	}
}

if $marchcps == 1 {
	if tm(1979m1) <= $date & $date <= tm(1997m12) {
		replace hoursu1 = ernush
		replaces hoursu1 = . if hoursu1 == 0
	}
	if tm(1998m1) <= $date {
		replace hoursu1 = a_uslhrs
	}
}

replace hoursut = . if hoursut < 0
lab var hoursut "Usual hours worked per week, all jobs"
lab def hoursut 198 "198+"
lab val hoursut hoursut
notes hoursut: Only in May/Basic available 1994-present
notes hoursut: 1979-1993 March: 'Hours vary' coded as 0 
notes hoursut: 1994-present CPS May/Basic: pehruslt
notes hoursut: 1979-1997 Unicon March: ernush
notes hoursut: 1997-present CPS March: a_uslhrs
