********************************************************************************
* Family income
********************************************************************************
capture rename faminc oldfaminc
gen faminc = .

if $monthlycps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace faminc = oldfaminc + 1 if oldfaminc <= 5 & oldfaminc >= 0
		replace faminc = oldfaminc if 5 < oldfaminc & oldfaminc < 19
		replace faminc = . if oldfaminc == 19
	}
	if tm(1994m1) <= $date & $date <= tm(2009m12) {
		replace faminc = hufaminc if hufaminc <= 12 & hufaminc >= 0
		replace faminc = hufaminc - 1 if hufaminc > 12
	}
	if tm(2010m1) <= $date {
		replace faminc = hefaminc if hefaminc <= 12 & hefaminc >= 0
		replace faminc = hefaminc - 1 if hefaminc > 12
	}
}

#delimit ;
lab def faminc
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
12 "$50,000 - $74,999"
13 "$75,000 - $99,999 (2003m10-present) / $75,000+ (1989-2003m9)"
14 "$100,000 - $149,999 (2003m10-present)"
15 "$150,000+ (2003m10-present)"
;
#delimit cr;
lab val faminc faminc
lab var faminc "Family income category"
notes faminc: Categories 13-15 differ after 2003m9
notes faminc: 1989-1993: Unicon faminc
notes faminc: 1994-2009: CPS hufaminc
notes faminc: 2010-present: CPS hefaminc
