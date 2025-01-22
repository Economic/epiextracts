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
	if tm(1962m1) <= $date & $date <= tm(1997m12) {
		replace occcode = occ
		replace occcode = . if occcode < 1
	}
	if tm(1998m1) <= $date & $date <= tm(2002m12) {
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
notes occcode: 1973-1993 Unicon Basic: occ
notes occcode: 1994-2021 CPS Basic: peio1ocd
notes occcode: 2021-present CPS Basic: ptio1ocd
notes occcode: 1962-1997 Unicon March: occ
notes occcode: 1998-2002 CPS March: a_occ
notes occcode: 2003-present CPS March: peioocc
