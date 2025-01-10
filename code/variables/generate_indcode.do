********************************************************************************
* Industry recode
****************************************************************
* recode Census industry variable for all dates
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

if $marchcps == 1 {
    if tm(1988m1) <= $date {
        replace indcode = industry
        replace indcode = . if industry == 0
    }
}

lab var indcode "Industry recode"
label value indcode indcode

