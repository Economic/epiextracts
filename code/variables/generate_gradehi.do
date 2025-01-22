********************************************************************************
* Education: gradehi
********************************************************************************
gen gradehi = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1988m12) {
		* adjust grdhi to be consistent across 1973-1991
		replace gradehi = grdhi - 1 
	}
	if tm(1989m1) <= $date & $date <= tm(1991m12) {
		replace gradehi = grdhi
	}
}
if $marchcps == 1 {
	if tm(1968m1) <= $date & $date <= tm(1987m12) {
		replace gradehi = grdhi - 1 if 0 < grdhi
	}
	if tm(1988m1) <= $date & $date <= tm(1991m12) {
		replace gradehi = grdhi if 0 < grdhi
	}
}

lab var gradehi "Highest grade attended"
#delimit ;
lab define gradehi
0 "None, 0, or K"
1 "1st grade"
2 "2nd grade"
3 "3rd grade"
4 "4th grade"
5 "5th grade"
6 "6th grade"
7 "7th grade"
8 "8th grade"
9 "9th grade"
10 "10th grade"
11 "11th grade"
12 "12th grade"
13 "College: 13th grade"
14 "College: 14th grade"
15 "College: 15th grade"
16 "College: 16th grade"
17 "College: 17th grade"
18 "College: 18th+ grade"
;
#delimit cr
lab val gradehi gradehi
notes gradehi: Only available 1973-1991
notes gradehi: 1973-1991 Unicon May/Basic: grdhi
notes gradehi: 1968-1991 Unicon March: grdhi
