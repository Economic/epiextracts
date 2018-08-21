********************************************************************************
* Education: educ
********************************************************************************
gen byte educ = .
if tm(1973m1) <= $date & $date <= tm(1991m12) {
	* none - 11th
	replace educ = 1 if 0 <= gradehi & gradehi <= 11
	* did not complete 12th
	replace educ = 1 if gradehi == 12 & grdcom == 2
	* did complete 12th
	replace educ = 2 if gradehi == 12 & grdcom == 1
	* college: 1-3 yrs
	replace educ = 3 if gradehi >= 13 & gradehi <= 15
	* did not complete college
	replace educ = 3 if gradehi == 16 & grdcom == 2
	* did complete college
	replace educ = 4 if gradehi == 16 & grdcom == 1
	* 4-5 years of college
	replace educ = 4 if gradehi == 17
	* more than 5 years of college
	replace educ = 5 if gradehi == 18
}
if tm(1992m1) <= $date & $date <= tm(1993m12) {
	* LTHS
	replace educ = 1 if 31 <= grdatn & grdatn <= 37
	* HS; includes "no diploma"
	replace educ = 2 if 38 <= grdatn & grdatn <= 39
	* Some college; includes associate's degrees
	replace educ = 3 if 40 <= grdatn & grdatn <= 42
	* College
	replace educ = 4 if grdatn == 43
	* Advanced degree
	replace educ = 5 if 44 <= grdatn & grdatn <= 46
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	* LTHS
	replace educ = 1 if 31 <= peeduca & peeduca <= 37
	* HS; includes "no diploma"
	replace educ = 2 if 38 <= peeduca & peeduca <= 39
	* Some college; includes associate's degrees
	replace educ = 3 if 40 <= peeduca & peeduca <= 42
	* College
	replace educ = 4 if peeduca == 43
	* Advanced degree
	replace educ = 5 if 44 <= peeduca & peeduca <= 46
}
lab var educ "Education level"
#delimit ;
lab define educ
1 "Less than high school"
2 "High school"
3 "Some college"
4 "College"
5 "Advanced"
;
#delimit cr
lab val educ educ
notes educ: Follows Jaeger (1997) classifications
notes educ: 1973-1991 Unicon: grdhi, grdcom
notes educ: 1992-1993 Unicon: grdatn
notes educ: 1994-present CPS: derived from peeduca
