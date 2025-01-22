*******************************************************************************
* Discouraged worker
*******************************************************************************
gen byte discwork = .

if $monthlycps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace discwork = 0
		replace discwork = 1 if dscwk == 1
	}
	if tm(1994m1) <= $date {
		replace discwork = 0
		replace discwork = 1 if 1 <= prdisc & prdisc <= 2
	}
}

if $marchcps == 1 {
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		replace discwork = 0
		replace discwork = 1 if 1 <= dscwk & dscwk <= 2
	}
	if tm(1998m1) <= $date {
		replace discwork = 0
		replace discwork = 1 if 1 <= prdisc & prdisc <= 2
	}
}

lab var discwork "Discourged worker"
lab def discwork 1 "Discouraged worker" 0 "Not discouraged worker"
lab val discwork discwork
notes discwork: Only available 1989-present Basic and 1994-present March
notes discwork: Definition/universe change 1989-1993, 1994-present
notes discwork: 1989-1993 Unicon Basic: dscwk
notes discwork: 1994-1997 Unicon March: dscwk
notes discwork: 1994/1998-present CPS Basic/March: prdisc
