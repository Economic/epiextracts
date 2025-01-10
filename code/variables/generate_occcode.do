********************************************************************************
* Occupation code
********************************************************************************
gen int occcode = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12)	{
		replace occcode = occ
	}
	if tm(1994m1) <= $date & $date <= tm(2021m2) {
		replace occcode = peio1ocd
	}
	if tm(2021m3) <= $date {
		replace occcode = ptio1ocd
	}

	replace occcode = . if occcode < 1
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1967m12) {
		replace occcode = dtld_occ
		replace occcode = . if dtld_occ < 1
	}
	if tm(1968m1) <= $date & $date <= tm(1987m12) {
		replace occcode = occupation
		replace occcode = . if occupation < 1
	}
	if tm(1988m1) <= $date & $date <= tm(2002m12) {
		replace occcode = a_occ
		replace occcode = . if a_occ < 1
	}
	if tm(2003m1) <= $date {
		replace occcode = peioocc
		replace occcode = . if peioocc < 1
	}
}

lab var occcode "Occupation: original census code"
notes occcode: Not consistent over time
notes occcode: 1973-1993 Unicon: occ
notes occcode: 1994-2021 CPS: peio1ocd
notes occcode: 2021-present CPS: ptio1ocd
