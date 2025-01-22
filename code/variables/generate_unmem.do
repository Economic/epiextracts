*******************************************************************************
* Union membership
*******************************************************************************
capture rename unmem old_unmem
gen byte unmem = .

if $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace unmem = 0 if old_unmem == 1
		replace unmem = 1 if old_unmem == 0
 	}
}

if $monthlycps == 1 {
	if tm(1983m1) <= $date & $date <= tm(1993m12) {
		replace unmem = 0 if old_unmem == 2
		replace unmem = 1 if old_unmem == 1
	}
	if tm(1994m1) <= $date {
		replace unmem = 0 if peernlab == 2
		replace unmem = 1 if peernlab == 1
	}
}

if $marchcps == 1 {
	if tm(1971m1) <= $date & $date <= tm(1997m12) {
		replace unmem = 0 if unmem == 2
		replace unmem = 1 if unmem == 1
	}

	if tm(1998m1) <= $date {
		replace unmem = 0 if a_unmem == 2
		replace unmem = 1 if a_unmem == 1
	}

}

lab var unmem "Member of a union"
lab def unmem 1 "Union member" 0 "Not a union member"
lab val unmem unmem
notes unmem: Only available in 1973-1981 May, 1983-present ORG
notes unmem: Not available in 1982
notes unmem: 1973-1993 Unicon Basic: unmem
notes unmem: 1994-present CPS Basic: peernlab
notes unmem: 1971-1997 Unicon March: unmem
notes unmem: 1998-present CPS March: a_unmem
