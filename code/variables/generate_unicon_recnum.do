********************************************************************************
* Unicon record number
********************************************************************************
gen byte unicon_recnum = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		replace unicon_recnum = recnum
		duplicates report unicon_recnum
		assert r(unique_value) == r(N)
	}
	if tm(1994m1) <= $date {
		* not available
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1997m12) {
		replace unicon_recnum = recnum
		duplicates report unicon_recnum
		assert r(unique_value) == r(N)
	}
	if tm(1998m1) <= $date {
		* not available
	}
}

lab var unicon_recnum "Unicon unique person record, 1973-1993"
notes unicon_recnum: 1973-1993: Unicon: recnum
notes unicon_recnum: Used for joining EPI extracts to Unicon data
