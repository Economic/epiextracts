********************************************************************************
* Composite basic monthly weight
********************************************************************************
gen cmpwgt = .
if tm(1998m1) <= $date {
	replace cmpwgt = pwcmpwgt
}
replace cmpwgt = . if cmpwgt < 0
lab var cmpwgt "Composited final monthly weight"
notes cmpwgt: Available only 1998-present
notes cmpwgt: Sum to civilian, non-institutional population age > 16 in each month
notes cmpwgt: Use to replicate BLS statistics
notes cmpwgt: 1998-present CPS: pwcmpwgt
