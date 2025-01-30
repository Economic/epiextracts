********************************************************************************
* Month in sample
********************************************************************************
gen byte minsamp = .

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1962m12) {
		replace minsamp = mis
		replace minsamp = . if minsamp == 9
		assert minsamp >= 1 & minsamp <= 8 | minsamp == .
	}
	if tm(1963m1) <= $date & $date <= tm(1966m12) {
		replace minsamp = mis
		assert minsamp >= 1 & minsamp <= 8
	}
	if tm(1967m1) <= $date & $date <= tm(1967m12) {
		replace minsamp = mis
		replace minsamp = . if minsamp == 9
		assert minsamp >= 1 & minsamp <= 8 | minsamp == .
	}
	if tm(1968m1) <= $date & $date <= tm(1997m12) {
		replace minsamp = mis
		assert minsamp >= 1 & minsamp <= 8
	}
	if tm(1998m1) <= $date {
		replace minsamp = h_mis
		assert minsamp >= 1 & minsamp <= 8
	}
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
notes minsamp: Caution using data in 1962 and 1967.
notes minsamp: 1973-1993 Unicon Basic: mis
notes minsamp: 1994-present CPS Basic: hrmis
notes minsamp: 1962-1997 Unicon March: mis
notes minsamp: 1998-present CPS March: h_mis
