*******************************************************************************
* Teleworked last week
*******************************************************************************
gen byte telework = .

if $monthlycps == 1 {
	if tm(2022m10) <= $date & $date <= tm(2024m5) {
		replace telework = ptcovr1
	}
	if tm(2024m6) <= $date {
		replace telework = pttlwk
	}
}

replace telework = 0 if telework == 2
replace telework = . if telework < 0

lab var telework "Teleworked last week"
lab def telework 0 "Did not telework" 1 "Teleworked"
lab val telework telework
notes telework: Universe restricted to employed at work
notes telework: Only available 2022m10-present
notes telework: 2022m10-2024m5 CPS: ptcovr1
notes telework: 2024m6-present CPS: pttlwk