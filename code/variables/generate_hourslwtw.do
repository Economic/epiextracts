*******************************************************************************
* Hours teleworked last week
*******************************************************************************
gen byte hourstwlw = .

if $monthlycps == 1 {
	if tm(2022m10) <= $date & $date <= tm(2024m5) {
		replace hourstwlw = ptcovr2
	}
	if tm(2024m6) <= $date {
		replace hourstwlw = pttlwkhr
	}
}

replace hourstwlw = . if hourstwlw < 0

lab var hourstwlw "Hours teleworked last week"
lab def hourstwlw 99 "99+"
lab val hourstwlw hourstwlw
notes hourstwlw: Universe restricted to employed at work
notes hourstwlw: Only available 2022m10-present
notes hourstwlw: 2022-2024 CPS: ptcovr2
notes hourstwlw: 2022-2024 CPS: pttlwkhr