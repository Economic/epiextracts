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
}

lab var occcode "Occupation: original census code"
notes occcode: Not consistent over time
notes occcode: 1973-1993 Unicon: occ
notes occcode: 1994-2021 CPS: peio1ocd
notes occcode: 2021-present CPS: ptio1ocd
