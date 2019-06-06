********************************************************************************
* ORG weight
********************************************************************************
gen orgwgt = .

if $marchcps == 1 {
	if tm(1979m1) <= $date & $date <= tm(1997m12) {
		replace orgwgt = ernwgt / 100
	}
	if tm(1998m1) <= $date {
		replace orgwgt = a_ernlwt
	}
}

if $monthlycps == 1 | $maycps == 1 {
	if tm(1979m1) <= $date & $date <= tm(1993m12) {
		* to ensure this runs on 1979-1981 basic, when ORG is a separate file
		* and ernwgt is missing in basic
		capture confirm variable ernwgt
		if _rc==0 {
			replace orgwgt = ernwgt / 100
		}
	}
	if tm(1994m1) <= $date {
		replace orgwgt = pworwgt
		* use Census 2000-based weights for 2000-2002
		if tm(2000m1) <= $date & $date <= tm(2002m12) {
			replace orgwgt = nworwgt
		}
	}
}

replace orgwgt = . if orgwgt <= 0

lab var orgwgt "Earnings weight"
notes orgwgt: Only for information collected only in ORG
notes orgwgt: Sum to civilian, non-institutional population in each month
notes orgwgt: To obtain approximate US population with full year of data, /*
*/ divide orgwgt by 12
notes orgwgt: 1994-present CPS: pworwgt
notes orgwgt: 1979-1993 Unicon: ernwgt
