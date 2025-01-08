********************************************************************************
* citistat: Citizenship status, detailed
********************************************************************************
gen byte citistat = .

if $monthlycps == 1 | $marchcps == 1 {
	if tm(1994m1) <= $date {
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
notes citistat: 1994-present CPS: prcitshp
