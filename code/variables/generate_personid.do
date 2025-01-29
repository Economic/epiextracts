********************************************************************************
* Consistent person id within household
********************************************************************************
gen personid = .

if $monthlycps == 1 {
	if tm(1998m1) <= $date {
		destring occurnum, replace
		replace personid = occurnum
	}
}

if $marchcps == 1 {
	* data 2003-2004 can't be forced to float
	if tm(2005m1) <= $date {
		destring peridnum, replace
		replace personid = peridnum
	}
}

lab var personid "Person identifer (unique within household-month)"
notes personid: Person ID unique within year, month, hhid
notes personid: 1998-present Basic: occurnum
notes personid: 2003-present March: peridnum
