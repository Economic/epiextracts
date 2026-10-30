********************************************************************************
* County
********************************************************************************
gen countyfips = .

if $monthlycps == 1 {
	if tm(1995m9) <= $date & $date <= tm(2004m4) {
		replace countyfips = geco
	}
	if tm(2004m5) <= $date {
		replace countyfips = gtco
	}
}

if $marchcps == 1 {
	if tm(1996m1) <= $date & $date <= tm(1997m12) {
		replace countyfips = cntyfp
	}
	if tm(1998m1) <= $date & $date <= tm(2004m12) {
		replace countyfips = geco
	}
	if tm(2005m1) <= $date {
		replace countyfips = gtco
	}
}

lab var countyfips "County - FIPS code"
lab def countyfips 0 "Not identified"
lab val countyfips countyfips
notes countyfips: 1995m9-2004m4, CPS: geco
notes countyfips: 2004m5-present, CPS: gtco
notes countyfips: 1996-1998 Unicon March: cntyfp
notes countyfips: 1998-2004 CPS March: geco
notes countyfips: 2005-present CPS March: gtco
notes countyfips: Not consistent over time
