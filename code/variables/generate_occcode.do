********************************************************************************
* Occupation code
********************************************************************************
gen int occcode = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12)	{
		replace occcode = occ
	}
	if tm(1994m1) <= $date {
		replace occcode = peio1ocd
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1997m12) {
		replace occcode = occ
	}
	if tm(1998m1) <= $date & $date <= tm(2002m12) {
		replace occcode = a_occ
	}
	if tm(2003m1) <= $date {
		replace occcode = peioocc
	}
}

lab var occcode "Occupation: original census code"
notes occcode: Not consistent over time
notes occcode: 1973-1993/1997 Unicon: occ
notes occcode: 1994-present CPS basic/may: peio1ocd
notes occcode: 1998-2002 CPS march: a_occ
notes occcode: 2003-present CPS march: peioocc
