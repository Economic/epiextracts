********************************************************************************
* Family income, detailed
********************************************************************************
gen faminc_det = .

if $monthlycps == 1 {
	if tm(2010m1) <= $date {
		replace faminc_det = hefaminc
	}
}

#delimit ;
lab def faminc_det
1 "Less than $5,000"
2 "$5,000 - $7,499"
3 "$7,500 - $9,999"
4 "$10,000 - $12,499"
5 "$12,500 - $14,999"
6 "$15,000 - $19,999"
7 "$20,000 - $24,999"
8 "$25,000 - $29,999"
9 "$30,000 - $34,999"
10 "$35,000 - $39,999"
11 "$40,000 - $49,999"
12 "$50,000 - $59,999"
13 "$60,000 - $74,999"
14 "$75,000 - $99,999"
15 "$100,000 - $149,999"
16 "$150,000+"
;
#delimit cr;
lab val faminc_det faminc_det
lab var faminc_det "Family income category, detailed"
notes faminc_det: 2010-present: CPS hefaminc
