*******************************************************************************
* Number of own children
*******************************************************************************
gen byte ownchild = .
if tm(1984m1) <= $date & $date <= tm(1993m12) {
	replace ownchild = pfnocd - 1 if (famrel == 1 | famrel == 2) & pfnocd >= 1
}
if tm(1999m11) <= $date {
	replace ownchild = prnmchld if (prfamrel == 1 | prfamrel == 2) & prnmchld >= 0
}
#delimit cr
lab val ownchild ownchild
notes ownchild: Number of own children in primary family
notes ownchild: Universe: family reference person or spouse
notes ownchild: 1984m1-1984m4: topcode=4
notes ownchild: 1984m5-1993: topcode=8
notes ownchild: 1984-1993 Unicon: pfnocd
notes ownchild: 1999m11-present CPS: prnmchld
