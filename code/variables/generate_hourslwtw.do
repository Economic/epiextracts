*******************************************************************************
* Hours teleworked last week
*******************************************************************************
gen byte hourslwtw = .

if $monthlycps == 1 {
	if tm(2022m10) <= $date & $date <= tm(2024m5) {
		replace hourslwtw = ptcovr2
	}
	if tm(2024m6) <= $date {
		replace hourslwtw = pttlwkhr
	}
}

replace hourslwtw = . if hourslwtw < 0

lab var hourslwtw "Hours teleworked last week"
lab def hourslwtw 99 "99+"
lab val hourslwtw hourslwtw
notes hourslwtw: Universe restricted to employed at work
notes hourslwtw: Only available 2022m10-present
notes hourslwtw: 2022m10-2024m5 CPS: ptcovr2
notes hourslwtw: 2024m6-present CPS: pttlwkhr