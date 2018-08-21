********************************************************************************
* Age
********************************************************************************
if tm(1976m1) <= $date & $date <= tm(1993m12) {
	* age already exists in Unicon data
}
if tm(1994m1) <= $date & $date <= tm(2012m4) {
	gen int age = .
	replace age = peage
}
if tm(2012m5) <= $date & $date <= tm(2018m5) {
	gen int age = .
	replace age = prtage
}
replace age = . if age < 0
recode age (80/max = 80)
cap lab drop age
lab def age 80 "80+"
lab val age age
lab var age "Age"
notes age: 1976-1993 Unicon: age
notes age: 1994-2012 CPS: peage
notes age: 2013-present CPS: prtage
notes age: top-coded at 80 for consistency across years
notes age: 1976-1981 range 14-80
notes age: 1982-present range 0-80
