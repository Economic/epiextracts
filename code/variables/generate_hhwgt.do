********************************************************************************
* Household weight
********************************************************************************
capture rename hhwgt oldhhwgt
gen hhwgt = .

if $monthlycps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace hhwgt = oldhhwgt / 100
	}
	if tm(1994m1) <= $date {
		replace hhwgt = hwhhwgt / 10000
	}
}

lab var hhwgt "Household weight"
notes hhwgt: Household weight, based on head of household
notes hhwgt: 1989-1993: Unicon hhwgt
notes hhwgt: 1994-present: CPS hwhhwgt
