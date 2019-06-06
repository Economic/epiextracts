********************************************************************************
* Hispanic ethnicity
********************************************************************************
gen byte hispanic = 0

if $marchcps == 1 {
	if tm(1998m1) <= $date & $date <= tm(2002m12) {
		replace hispanic = 1 if 1 <= a_reorgn & a_reorgn <= 7
	}
	if tm(2003m1) <= $date & $date <= tm(2013m12) {
		replace hispanic = 1 if 1 <= prdthsp & prdthsp <= 5
	}
	if tm(2014m1) <= $date {
		replace hispanic = 1 if 1 <= prdthsp & prdthsp <= 8
	}
}

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		if tm(1974m1) <= $date & $date <= tm(1988m12) {
			replace spneth = "" if spneth == "A"
			destring spneth, replace
		}
		replace hispanic = 1 if 1 <= spneth & spneth <= 7
	}
	if tm(1994m1) <= $date & $date <= tm(2002m12) {
		replace hispanic = 1 if 1 <= prorigin & prorigin <= 7
	}
	if tm(2003m1) <= $date & $date <= tm(2013m12) {
		replace hispanic = 1 if 1 <= prdthsp & prdthsp <= 5
	}
	if tm(2014m1) <= $date {
		replace hispanic = 1 if 1 <= prdthsp & prdthsp <= 8
	}
}

lab var hispanic "Hispanic ethnicity"
lab define hispanic 0 "Not hispanic" 1 "Hispanic"
lab val hispanic hispanic
notes hispanic: Hispanic ethnicity
notes hispanic: Definition breaks in 1994, 2003, 2014
notes hispanic: not Hispanic includes nonresponse, missing, etc., in order to be consistent with other race variables like wbho
notes hispanic: 1973-1993 Unicon: spneth
notes hispanic: 1994-2002 CPS: prorigin
notes hispanic: 2003-present CPS: prdthsp
