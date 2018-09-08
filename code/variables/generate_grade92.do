********************************************************************************
* Education: grade92
********************************************************************************
gen grade92 = .
if tm(1992m1) <= $date & $date <= tm(1993m12) {
	replace grade92 = grdatn - 30
}
if tm(1994m1) <= $date {
	replace grade92 = peeduca - 30
}
lab var grade92 "Education level, detailed, post-1991"
#delimit ;
lab define grade92
1  "Less than 1st grade"
2  "1st-4th grade"
3  "5th-6th grade"
4  "7th-8th grade"
5  "9th grade"
6  "10th grade"
7  "11th grade"
8  "12th grade-no diploma"
9  "HS graduate, GED"
10 "Some college but no degree"
11 "Associate degree-occupational/vocational"
12 "Associate degree-academic program"
13 "Bachelor's degree"
14 "Master's degree"
15 "Professional school"
16 "Doctorate"
;
#delimit cr;
lab val grade92 grade92
notes grade92: Only available 1992-present
notes grade92: 1992-1993 Unicon: grdatn
notes grade92: 1994-present CPS: peeduca
