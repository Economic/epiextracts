*******************************************************************************
* Enrolled in high school or college last week
*******************************************************************************
gen byte schenrl_type = .

if $marchcps == 1 {
	*check start and end months
	*1988 & 1988B have different underlying vars
	if tm(1986m1) <= $date & $date <= tm(1988m12) {
		replace schenrl_type = bhscolge
		replace schenrl_type = . if schenrl_type == 0
	}
	if tm(1989m1) <= $date {
		replace schenrl_type = a_hscol 
		replace schenrl_type = . if schenrl_type == 0
	}
}

lab var schenrl "Enrolled in high school or college last week"
lab def schenrl 1 "Enrolled" 0 "Not enrolled"
lab val schenrl schenrl
notes schenrl: Available 1986-present
notes schenrl: 1983-present universe: ages 16-24 attending school
notes schenrl: 1986-1988 Unicon March: bhscolge
notes schenrl: 1989-1997 Unicon March: a_hscol
notes schenrl: 1997-present CPS March: a_hscol
