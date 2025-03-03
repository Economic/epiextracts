**Wages top-coded
********************************************************************************
gen byte tc_earnhour = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1989m1) <= $date & $date <= tm(1993m12) {
			replace tc_earnhour = ernhtf if earnhour ~= .
		}
		if tm(1994m1) <= $date {
			replace tc_earnhour = pthr if earnhour ~= .
		}
	}
}

lab var tc_earnhour "Wages top-coded by BLS"
lab def tc_earnhour 0 "Not top-coded" 1 "Top-coded"
lab val tc_earnhour tc_earnhour
notes tc_earnhour: 1989-1993 Unicon: ernhtf
notes tc_earnhour: 1994-present CPS: pthr
