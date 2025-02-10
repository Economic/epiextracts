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
	if tm(1963m1) <= $date & $date <= tm(1975m12) {
		replace ownchild = child18
		replace ownchild = . if ownchild == 10
	}
	if tm(1976m1) <= $date & $date <= tm(1997m12) {
		replace ownchild = child18
	}
	if tm(1998m1) <= $date {
		replace ownchild = fownu18
	}
}

lab var ownchild "Number of own children in primary family"
notes ownchild: Universe: family reference person or spouse
notes ownchild: 1963-1967 March: topcode=7
notes ownchild: 1967-present March: topcode=9
notes ownchild: 1984m1-1984m4 Basic: topcode=4
notes ownchild: 1984m5-1993 Basic: topcode=8
notes ownchild: 1984-1993 Unicon: pfnocd
notes ownchild: 1999m11-present CPS: prnmchld
notes ownchild: 1963-1997 Unicon March: child18
notes ownchild: 1998-present CPS March: fownu18
