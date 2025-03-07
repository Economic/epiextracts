********************************************************************************
* Industry: original Census code
****************************************************************
gen int indcode = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12)	{
		replace indcode = ind
	}
	if tm(1994m1) <= $date {
		replace indcode = peio1icd
		replace indcode = . if indcode < 0
	}
	
}


lab val indcode indcode
label var indcode "Industry: original Census code"
notes indcode: Not consistent over time
notes indcode: 1973-1993 Unicon: ind
notes indcode: 1994-present CPS: peio1icd
