********************************************************************************
* Family income
********************************************************************************
capture rename faminc oldfaminc
gen faminc = .

if $monthlycps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace faminc = oldfaminc + 1 if oldfaminc <= 5
		replace faminc = oldfaminc if 5 < oldfaminc & oldfaminc < 19
		replace faminc = . if oldfaminc == 19
	}
	if tm(1994m1) <= $date & $date <= tm(2009m12) {
		replace faminc = hufaminc if hufaminc <= 12
		replace faminc = hufaminc - 1 if hufaminc > 12
	}
	if tm(2010m1) <= $date {
		replace faminc = hefaminc if hefaminc <= 12
		replace faminc = hefaminc - 1 if hefaminc > 12
	}
}

if $marchcps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1994m12) {
		replace faminc = hfminc + 1 if 0 <= hfminc & hfminc <= 10
		replace faminc = 12 if 11 <= hfminc & hfminc <= 12
		replace faminc = hfminc if 13 <= hfminc & hfminc < 19
	}
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace faminc = hfminc + 1 if 0 <= hfminc & hfminc <= 10
		replace faminc = 12 if 11 <= hfminc & hfminc <= 12
		replace faminc = hfminc if 13 <= hfminc & hfminc < 19
	}
	if tm(1998m1) <= $date & $date <= tm(2004m12) {
		replace faminc = h_faminc + 1 if 0 <= h_faminc & h_faminc <= 10
		replace faminc = 12 if 11 <= h_faminc & h_faminc <= 12
		replace faminc = h_faminc if 13 <= h_faminc & h_faminc < 19
	}
	if tm(2005m1) <= $date & $date <= tm(2009m12) {
		replace faminc = hufaminc if 0 < hufaminc & hufaminc <= 11
		replace faminc = 12 if 12 <= hufaminc & hufaminc <= 13
		replace faminc = hufaminc - 1 if 14 <= hufaminc
	}
	if tm(2010m1) <= $date & $date <= tm(2018m12) {
		replace faminc = hefaminc if 0 < hefaminc & hefaminc <= 11
		replace faminc = 12 if 12 <= hefaminc & hefaminc <= 13
		replace faminc = hefaminc - 1 if 14 <= hefaminc
	}
	if tm(2019m1) <= $date {
		replace faminc = 1 if ftot_r <= 2
		replace faminc = ftot_r - 1 if 2 < ftot_r & ftot_r <= 6
		replace faminc = 6 if 7 <= ftot_r & ftot_r <= 8
		replace faminc = 7 if 9 <= ftot_r & ftot_r <= 10
		replace faminc = 8 if 11 <= ftot_r & ftot_r <= 12
		replace faminc = 9 if 13 <= ftot_r & ftot_r <= 14
		replace faminc = 10 if 15 <= ftot_r & ftot_r <= 16
		replace faminc = 11 if 17 <= ftot_r & ftot_r <= 20
		replace faminc = 12 if 21 <= ftot_r & ftot_r <= 30
		replace faminc = 13 if 31 <= ftot_r & ftot_r <= 40
		replace faminc = 14 if 41 <= ftot_r & ftot_r  
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
13 "$75,000 - $99,999 (2003m10-present) / $75,000+ (CPS: 1989-2003m9) / 75000+ (March: 1988-2004)"
14 "$100,000 - $149,999 (2003m10-present) / (March: 2005-present)"
15 "$150,000+ (2003m10-present) / (March: 2005-present)"
;
#delimit cr;
lab val faminc faminc
lab var faminc "Family income category"
notes faminc: Categories 13-15 differ after 2003m9
notes faminc: 1989-1993: Unicon faminc
notes faminc: 1994-2009: CPS hufaminc
notes faminc: 2010-2018: CPS hefaminc
notes faminc: 2019: CPS ftot_r
