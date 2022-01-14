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
		replace hoursut = ernush
	}
	if tm(1998m1) <= $date {
		replace hoursut = a_uslhrs
	}
}

replace hoursut = . if hoursut < 0
lab var hoursut "Usual hours worked per week, all jobs"
lab def hoursut 198 "198+"
lab val hoursut hoursut
notes hoursut: Only available 1994-present (CPS)
notes hoursut: 1994-present CPS: pehruslt
notes hoursut: 1979-1997 Unicon: ernush
notes hoursut: 1998-present CPS: a_uslhrs 
