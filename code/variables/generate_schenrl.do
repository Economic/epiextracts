*******************************************************************************
* Enrolled in high school or college last week
*******************************************************************************
gen byte schenrl = .

if $monthlycps == 1 {
	if tm(1984m1) <= $date & $date <= tm(1993m12) {
		replace schenrl = 0 if schenr == 2
		replace schenrl = 1 if schenr == 1
	}
	if tm(1994m1) <= $date {
		replace schenrl = 0 if peschenr == 2
		replace schenrl = 1 if peschenr == 1
	}
}

lab var schenrl "Enrolled in high school or college last week"
lab def schenrl 1 "Enrolled" 0 "Not enrolled"
lab val schenrl schenrl
notes schenrl: Available 1993-present
notes schenrl: 1983-2012 universe: ages 16-24
notes schenrl: 2013-present universe: ages 16-54
notes schenrl: 1984-1993 Unicon: schenr
notes schenrl: 1994-present CPS: peschenr
