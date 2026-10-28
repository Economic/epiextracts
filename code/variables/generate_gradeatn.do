********************************************************************************
* Education: gradeatn
********************************************************************************
gen gradeatn = .
if $monthlycps == 1 {
	if tm(1992m1) <= $date & $date <= tm(1993m12) {
		replace gradeatn = grdatn - 30
		replace gradeatn = . if gradeatn == -31
	}
	if tm(1994m1) <= $date {
		replace gradeatn = peeduca - 30
		replace gradeatn = . if gradeatn == -31
	}
}

if $marchcps == 1 {
	if tm(1992m1) <= $date & $date <= tm(1997m12) {
		replace gradeatn = grdatn - 30
		replace gradeatn = . if gradeatn <= 0
	}
	if tm(1998m1) <= $date {
		replace gradeatn = a_hga - 30
		replace gradeatn = . if gradeatn <= 0

	}
}

lab var gradeatn "Education level attained, detailed, post-1991"
#delimit ;
lab define gradeatn
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
lab val gradeatn gradeatn
notes gradeatn: Only available 1992-present
notes gradeatn: 1992-1993 Unicon Basic: grdatn
notes gradeatn: 1994-present CPS Basic: peeduca
notes gradeatn: 1988-1997 Unicon March: grdatn
notes gradeatn: 1998-present CPS March: a_hga
