********************************************************************************
* Consistent household id
********************************************************************************
gen hhid = .
if tm(1998m1) <= $date {
	destring qstnum, replace
	replace hhid = qstnum
}
lab var hhid "Household identifer (unique within month)"
notes hhid: Household ID unique within year and month
notes hhid: 1998-present: CPS qstnum
