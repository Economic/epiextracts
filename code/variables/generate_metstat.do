********************************************************************************
* metstat: metro status
********************************************************************************
capture rename metstat orig_metstat
gen metstat = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		if $monthlycps == 0 & $maycps == 1 & $date <= tm(1976m12) {
			replace metstat = 1 if citystat == 1 | citystat == 2
			replace metstat = 0 if citystat == 3
	 	}
		else {
			replace metstat = 1 if orig_metstat == 1
			replace metstat = 0 if orig_metstat == 2
		}
	}
	if (tm(1994m1) <= $date & $date <= tm(1995m5)) | (tm(1995m9) <= $date & $date <= tm(2004m4)) {
		replace metstat = 1 if gemetsta == 1
		replace metstat = 0 if gemetsta == 2
	}
	if tm(2004m5) <= $date {
		replace metstat = 1 if gtmetsta == 1
		replace metstat = 0 if gtmetsta == 2
	}
}

if $marchcps == 1 {
	if tm(1977m1) <= $date & $date <= tm(1997m12) {
		replace metstat = 0 if orig_metstat == 2
		replace metstat = 1 if orig_metstat == 1
	}
	if tm(1998m1) <= $date & $date <= tm(2003m12) {
		replace metstat = 0 if hmsa_r == 2
		replace metstat = 1 if hmsa_r == 1
	}
	if tm(2005m1) <= $date {
		replace metstat = 0 if gtmetsta == 2
		replace metstat = 1 if gtmetsta == 1
	}
}

lab var metstat "Metropolitan status"
lab def metstat 0 "Nometropolitan" 1 "Metropolitan"
lab val metstat metstat
notes metstat: 1973-1976 May Unicon: citystat
notes metstat: 1977-1981 May Unicon: citystat
notes metstat: 1976-1993 Basic Unicon: metstat
notes metstat: 1994-1995m5, 1995m9-2004m4 CPS: gemetsta
notes metstat: 2004m5-present CPS: gtmetsta
notes metstat: 1977-1997 Unicon March: metstat
notes metstat: 1998-2004 CPS March: hmsa_r
notes metstat: 2005-present CPS March: gtmetsta
notes metstat: Missing for all observations during 1995m6-1995m8
notes metstat: Based on SMSA central city/noncentral status for May 1973-1981
