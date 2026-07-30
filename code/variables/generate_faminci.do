********************************************************************************
* Family income intervalled
********************************************************************************
capture rename faminc oldfaminc
gen byte faminci = .

if $monthlycps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace faminci = oldfaminc + 1 if oldfaminc <= 5 & oldfaminc >= 0
		replace faminci = oldfaminc if 5 < oldfaminc & oldfaminc < 19
		replace faminci = . if oldfaminc == 19
	}
	if tm(1994m1) <= $date & $date <= tm(2009m12) {
		replace faminci = hufaminc if hufaminc <= 12 & hufaminc >= 0
		replace faminci = hufaminc - 1 if hufaminc > 12
	}
	if tm(2010m1) <= $date {
		replace faminci = hefaminc if hefaminc <= 12 & hefaminc >= 0
		replace faminci = hefaminc - 1 if hefaminc > 12
	}
}

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(1988m12) {
		replace faminci = hfminc + 1 if hfminc <= 10
		replace faminci = 12 if 11 <= hfminc & hfminc <= 12
		replace faminci = hfminc if 13 <= hfminc & hfminc < 19
	}
	if tm(1990m1) <= $date & $date <= tm(1997m12) {
		replace faminci = hfminc + 1 if hfminc <= 10
		replace faminci = 12 if 11 <= hfminc & hfminc <= 12
		replace faminci = hfminc if 13 <= hfminc & hfminc < 19
	}
	if tm(1998m1) <= $date & $date <= tm(2004m12) {
		replace faminci = h_faminc + 1 if h_faminc <= 10
		replace faminci = 12 if 11 <= h_faminc & h_faminc <= 12
		replace faminci = h_faminc if 13 <= h_faminc & h_faminc < 19
	}
	if tm(2005m1) <= $date & $date <= tm(2009m12) {
		replace faminci = hufaminc if hufaminc <= 11
		replace faminci = 12 if 12 <= hufaminc & hufaminc <= 13
		replace faminci = hufaminc - 1 if 14 <= hufaminc
	}
	if tm(2010m1) <= $date & $date <= tm(2018m12) {
		replace faminci = hefaminc if hefaminc <= 11
		replace faminci = 12 if 12 <= hefaminc & hefaminc <= 13
		replace faminci = hefaminc - 1 if 14 <= hefaminc
	}
	if tm(2019m1) <= $date {
		replace faminci = 1 if ftot_r <= 2
		replace faminci = ftot_r - 1 if 2 < ftot_r & ftot_r <= 6
		replace faminci = 6 if 7 <= ftot_r & ftot_r <= 8
		replace faminci = 7 if 9 <= ftot_r & ftot_r <= 10
		replace faminci = 8 if 11 <= ftot_r & ftot_r <= 12
		replace faminci = 9 if 13 <= ftot_r & ftot_r <= 14
		replace faminci = 10 if 15 <= ftot_r & ftot_r <= 16
		replace faminci = 11 if 17 <= ftot_r & ftot_r <= 20
		replace faminci = 12 if 21 <= ftot_r & ftot_r <= 30
		replace faminci = 13 if 31 <= ftot_r & ftot_r <= 40
		replace faminci = 14 if ftot_r == 41
	}
}

#delimit ;
lab def faminci
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
13 "$75,000 - $99,999 (2003m10-present) / $75,000+ (CPS: 1989-2003m9) / 75000+ (March: 1988-2004)"
14 "$100,000 - $149,999 (2003m10-present) / (March: 2005-present)"
15 "$150,000+ (2003m10-present) / (March: 2005-2018)"
;
#delimit cr;
lab val faminci faminci
lab var faminci "Family income intervalled"
notes faminci: Categories 13-15 differ after 2003m9
notes faminci: Census imputes hefaminc to remove missing — zero or near-zero missing rates reflect Census imputation, not complete reporting
notes faminci: 1989-1993 Unicon Basic: faminc
notes faminci: 1994-2009 CPS Basic: hufaminc
notes faminci: 2010-present CPS Basic: hefaminc
notes faminci: 1988-1997 Unicon March: hfminc
notes faminci: 1989 March: hfminc data missing
notes faminci: 1998-2004 CPS March: h_faminc
notes faminci: 2005-2009 CPS March: hufaminc
notes faminci: 2010-2018 CPS March: hefaminc
notes faminci: 2019-present CPS March: ftot_r
