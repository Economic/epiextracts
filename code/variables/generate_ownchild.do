*******************************************************************************
* Number of own children
*******************************************************************************
gen byte ownchild = .

if $monthlycps == 1 {
	if tm(1984m1) <= $date & $date <= tm(1993m12) {
		replace ownchild = pfnocd - 1 if (famrel == 1 | famrel == 2) & pfnocd >= 1
	}
	if tm(1999m11) <= $date {
		replace ownchild = prnmchld if (prfamrel == 1 | prfamrel == 2) & prnmchld >= 0
	}
}
if $marchcps == 1 {
	if tm(1976m1) <= $date & $date <= tm(1987m12) {
		replace ownchild = frcode10
	}
	if tm(1988m1) <= $date {
		replace ownchild = fownu18
	}
}

lab var ownchild "Number of own children in primary family"
notes ownchild: Universe: family reference person or spouse
notes ownchild: 1984m1-1984m4: topcode=4
notes ownchild: 1984m5-1993: topcode=8
notes ownchild: 1984-1993 Unicon: pfnocd
notes ownchild: 1999m11-present CPS: prnmchld
