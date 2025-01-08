********************************************************************************
* County
********************************************************************************
gen countyfips = .

if $monthlycps == 1 | $marchcps == 1 {
	if tm(1995m9) <= $date & $date <= tm(2004m4) {
		replace countyfips = geco
	}
	if tm(2004m5) <= $date {
		replace countyfips = gtco
}
}

lab var countyfips "County - FIPS code"
lab def countyfips 0 "Not identified"
lab val countyfips countyfips
notes countyfips: 1995m9-2004m4, CPS: geco
notes countyfips: 2004m5-present, CPS: gtco
notes countyfips: Not consistent over time
