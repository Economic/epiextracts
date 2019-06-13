********************************************************************************
* Consistent person id
********************************************************************************
gen personid = .

if $monthlycps == 1 {
	if tm(1998m1) <= $date {
		destring occurnum, replace
		replace personid = occurnum
	}
}

lab var personid "Person identifer (unique within household-month)"
notes personid: Person ID unique within year, month, hhid
notes personid: 1998-present: CPS occurnum
