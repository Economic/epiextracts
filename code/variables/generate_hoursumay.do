*******************************************************************************
* Usual hours worked per week, main job (May supplement)
*******************************************************************************
gen byte hoursumay = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace hoursumay = wkhrswk
	}
}
replace hoursumay = . if hoursumay < 0
lab var hoursumay "Usual hours worked per week at main job (May supplement)"
lab def hoursumay 99 "99+"
lab val hoursumay hoursumay
notes hoursumay: Only available for May supplement
notes hoursumay: 1973-1981 Unicon: wkhrswk
