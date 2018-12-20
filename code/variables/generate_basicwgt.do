********************************************************************************
* Basic monthly weight
********************************************************************************
gen basicwgt = .

* basic variable creation
if tm(1973m1) <= $date & $date <= tm(1997m12) {
	replace basicwgt = finalwgt
}
if tm(1998m1) <= $date {
	replace basicwgt = cmpwgt
	* use Census 2000-based weights for 2000-2002
	if tm(2000m1) <= $date & $date <= tm(2002m12) {
		replace basicwgt = nwcmpwgt
	}
}

* age restrictions
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	replace basicwgt = . if age < 16 | age == .
}
if tm(1994m1) <= $date & $date <= tm(2012m4) {
	replace basicwgt = . if peage < 16 | peage == .
}
if tm(2012m5) <= $date {
	replace basicwgt = . if prtage < 16 | prtage == .
}

lab var basicwgt "Basic monthly weight"
notes basicwgt: Sum to civilian, non-institutional population age > 16 in each month
notes basicwgt: Combination of finalwgt and pwcmpwgt, but defined only for age > 16
notes basicwgt: Used by EPI for most labor force statistics
notes basicwgt: 1973-1997: finalwgt
notes basicwgt: 1998-present: cmpwgt
