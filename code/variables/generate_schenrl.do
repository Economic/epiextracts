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

if $marchcps == 1 {
	*check start and end months
	*1988 & 1988B have different underlying vars
	if tm(1986m1) <= $date & $date <= tm(1988m12) {
		replace schenrl = 0 if battend == 2
		replace schenrl = 1 if battend == 1
		replace schenrl = . if battend == 0
	}
	if tm(1989m1) <= $date {
		replace schenrl = 0 if a_enrlw == 2
		replace schenrl = 1 if a_enrlw == 1
		replace schenrl = . if a_enrlw == 0
	}
}

lab var schenrl "Enrolled in high school or college last week"
lab def schenrl 1 "Enrolled" 0 "Not enrolled"
lab val schenrl schenrl
notes schenrl: Available 1993-present
notes schenrl: 1983-2012 universe: ages 16-24
notes schenrl: 2013-present universe: ages 16-54
notes schenrl: 1984-1993 Unicon Basic: schenr
notes schenrl: 1994-present CPS Basic: peschenr
notes schenrl: 1986-1988 Unicon March: battend
notes schenrl: 1989-1997 Unicon March: a_enrlw
notes schenrl: 1997-present CPS March: a_enrlw
