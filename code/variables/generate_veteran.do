********************************************************************************
* veteran: Veteran status
********************************************************************************

* first generate adjusted hourly earnings for non-paid-hourly
gen byte veteran = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1973m1) <= $date & $date <= tm(1993m12) {
			replace veteran = 0 if vet == 6
			replace veteran = 1 if 1 <= vet & vet <= 5
		}
		if tm(1994m12) <= $date & $date <= tm(2005m7) {
			replace veteran = 0 if peafwhen == 6
			replace veteran = 1 if 1 <= peafwhen & peafwhen <= 5
		}
		if tm(2005m8) <= $date {
			replace veteran = 0 if peafever == 2
			replace veteran = 1 if 1 <= peafwhn1 & peafwhn1 <= 9
		}
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1962m12) {
		replace veteran = 0 if vet == 5
		replace veteran = 1 if 0 <= vet & vet <= 4
	}
	if tm(1963m1) <= $date & $date <= tm(1967m12) {
		replace veteran = 1 if 1 <= vet & vet <= 9
		replace veteran = 0 if vet == 6
	}
	if tm(1968m1) <= $date & $date <= tm(1997m12) {
		replace veteran = 0 if vet == 6
		replace veteran = 1 if 1 <= vet & vet <= 5
	}
	if tm(1998m1) <= $date & $date <= tm(2005m12) {
		replace veteran = 0 if a_vet == 6
		replace veteran = 1 if 1 <= a_vet & a_vet <= 5
	}
	if tm(2006m1) <= $date {
		replace veteran = 0 if peafever == 2
		replace veteran = 1 if 1 <= peafwhn1 & peafwhn1 <= 9
	}
}

lab var veteran "Veteran status"
lab def veteran 0 "Not a veteran" 1 "Veteran"
lab val veteran veteran
notes veteran: universe restricted to men before 1989
notes veteran: Significant question change in 2005m8
notes veteran: 1973-1993 Unicon Basic: vet
notes veteran: 1994-2005m7 CPS Basic: peafwhen
notes veteran: 2005m8-present CPS: peafever, peafwhn1
notes veteran: 1962-1997 Unicon March: vet
notes vetern: 1998-present CPS March: peafever, peafwhn1
