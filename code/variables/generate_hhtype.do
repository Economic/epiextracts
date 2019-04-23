********************************************************************************
* Household record type
********************************************************************************
capture rename hhtype oldhhtype
gen hhtype = .
if tm(1984m1) <= $date & $date <= tm(1993m12) {
	replace hhtype = oldhhtype
}
if tm(1994m1) <= $date {
	replace hhtype = hrhtype
}
#delimit ;
lab def hhtype
0 "Noninterview household"
1 "Husband/wife primary family (neither Armed Forces)"
2 "Husband/wife primary family (either/both Armed Forces)"
3 "Unmarried civilian male primary family householder"
4 "Unmarried civilian female primary family householder"
5 "Unmarried primary family householder in Armed Forces"
6 "Civilian male primary individual"
7 "Civilian female primary individual"
8 "Primary individual in Armed Forces"
9 "Group quarters (1984-1993) / Group quarters with family (1994+)"
10 "Group quarters without family (1994+)"
;
#delimit cr;
lab val hhtype hhtype
lab var hhtype "Household type"
notes hhtype: Type of household
notes hhtype: 1984-1993: Unicon hhtype
notes hhtype: 1994-present: CPS hrhtype
