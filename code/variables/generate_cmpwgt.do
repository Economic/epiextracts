********************************************************************************
* Composite basic monthly weight
********************************************************************************
gen cmpwgt = .

if $monthlycps == 1 {
	if tm(1998m1) <= $date {
		replace cmpwgt = pwcmpwgt
		* use Census 2000-based weights for 2000-2002
		if tm(2000m1) <= $date & $date <= tm(2002m12) {
			replace cmpwgt = nwcmpwgt
		}
	}
	replace cmpwgt = . if cmpwgt <= 0
	lab var cmpwgt "Composited final monthly weight"
}

notes cmpwgt: Available only 1998-present
notes cmpwgt: Sum to civilian, non-institutional population age > 16 in each month
notes cmpwgt: Use to replicate BLS statistics
notes cmpwgt: 1998-present CPS: pwcmpwgt
