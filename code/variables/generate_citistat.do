********************************************************************************
* citistat: Citizenship status, detailed
********************************************************************************
capture rename citistat orig_citistat
gen byte citistat = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace citistat = prcitshp
		assert 1 <= prcitshp & prcitshp <= 5
	}
}

if $marchcps == 1 {
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		replace citistat = orig_citistat
	}
	if tm(1998m1) <= $date {
		replace citistat = prcitshp
		assert 1 <= prcitshp & prcitshp <= 5		
	}
}

label var citistat "Citizenship status, detailed"
#delimit ;
lab def citistat
1 "Native, born in US"
2 "Native, born in Puerto Rico or other US island areas"
3 "Native, born abroad with American parent(s)"
4 "Foreign born, naturalized US citizen"
5 "Foreign born, not a US citizen"
;
#delimit cr;
lab val citistat citistat
notes citistat: 1994-present CPS Basic: prcitshp
notes citistat: 1963-1997 Unicon March: citistat
notes citistat: 1998-present CPS March: prcitshp
