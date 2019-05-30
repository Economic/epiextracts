********************************************************************************
* Month in sample
********************************************************************************
gen byte minsamp = .

if $marchcps == 1 {
	replace mis = h_mis
}

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		replace minsamp = mis
		assert minsamp >= 1 & minsamp <= 8
	}
	if tm(1994m1) <= $date {
		replace minsamp = hrmis
		assert minsamp >= 1 & minsamp <= 8
	}
}

lab var minsamp "Month in sample"
notes minsamp: 1973 - 1993 Unicon: hrmis
notes minsamp: 1994 - present Basic/ORG CPS: hrmis
notes minsamp: 1994 - present March CPS: h_mis
