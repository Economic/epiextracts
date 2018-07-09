local date = `1'



********************************************************************************
* Age
********************************************************************************
if tm(1976m1) <= `date' & `date' <= tm(1993m1) {
	* age already exists
}

if tm(1994m1) <= `date' & `date' <= tm(2012m4) {
	gen int age = .
	replace age = peage
	replace age = . if peage < 0
}
if tm(2012m5) <= `date' & `date' <= tm(2018m5) {
	gen int age = .
	replace age = prtage
	replace age = . if prtage < 0
}
recode age (80/max = 80)
cap lab drop age
lab def age 80 "80+"
lab val age age
lab var age "Age"
notes age: 1976-1993 Unicon: age
notes age: 1994-2012 CPS: peage
notes age: 2013-present CPS: prtage
notes age: top-coded at 80 for consistency across years
notes age: 1976-1981 range 14-80
notes age: 1982-present range 0-80



********************************************************************************
* Gender
********************************************************************************
gen byte female = .
if tm(1973m1) <= `date' & `date' <= tm(1993m12) {
	replace female = 0 if sex == 1
	replace female = 1 if sex == 2
}
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace female = 0 if pesex == 1
	replace female = 1 if pesex == 2
}
lab var female "Female"
#delimit ;
lab define female
0 "Male"
1 "Female"
;
#delimit cr
lab val female female
notes female: 1976-1993 Unicon: sex
notes female: 1994-present CPS: pesex


********************************************************************************
* Education: gradehi
********************************************************************************
gen gradehi = .
if tm(1973m1) <= `date' & `date' <= tm(1988m12) {
	* adjust grdhi to be consistent across 1973-1991
	replace gradehi = grdhi - 1
}
if tm(1989m1) <= `date' & `date' <= tm(1991m12) {
	replace gradehi = grdhi
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
16 "College: 17th grade"
18 "College: 18th+ grade"
;
#delimit cr
lab val gradehi gradehi
notes gradehi: Only available 1973-1991
notes gradehi: 1973-1991 Unicon: grdhi


********************************************************************************
* Education: gradecom
********************************************************************************
gen gradecom = .
if tm(1973m1) <= `date' & `date' <= tm(1991m12) {
	replace gradecom = 1 if grdcom == 1
	replace gradecom = 0 if grdcom == 2
}
lab var gradecom "Completed highest grade attended"
lab define gradecom 0 "Not completed" 1 "Completed"
lab val gradecom gradecom
notes gradecom: Only available 1973-1991
notes gradecom: 1973-1991 Unicon: grdcom


********************************************************************************
* Education: grade92
********************************************************************************
gen grade92 = .
if tm(1992m1) <= `date' & `date' <= tm(1993m12) {
	replace grade92 = grdatn - 30
}
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
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

stop


********************************************************************************
* Education: educ
********************************************************************************
gen byte educ = .
if tm(1973m1) <= `date' & `date' <= tm(1991m12) {
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
if tm(1992m12) <= `date' & `date' <= tm(1993m12) {
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
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
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



********************************************************************************
* Race
********************************************************************************
gen byte wbho = .
if tm(1973m1) <= `date' & `date' <= tm(1988m12) {
	if tm(1974m1) <= `date' & `date' <= tm(1988m12) {
		replace spneth = "" if spneth == "A"
		destring spneth, replace
	}
	replace wbho = 1 if race == 1
	replace wbho = 2 if race == 2
	replace wbho = 4 if race == 3
	replace wbho = 3 if (1 <= spneth & spneth <= 7)
}
if tm(1989m1) <= `date' & `date' <= tm(1993m12) {
	replace wbho = 1 if race == 1
	replace wbho = 2 if race == 2
	replace wbho = 4 if (3 <= race & race <= 5)
	replace wbho = 3 if (1 <= spneth & spneth <= 7)
}
if tm(1994m1) <= `date' & `date' <= tm(1995m12) {
	replace wbho = 1 if perace == 1
	replace wbho = 2 if perace == 2
	replace wbho = 4 if (3 <= perace & perace <= 5)
	replace wbho = 3 if (1 <= prorigin & prorigin <= 7)
}
if tm(1996m1) <= `date' & `date' <= tm(2002m12) {
	replace wbho = 1 if perace == 1
	replace wbho = 2 if perace == 2
	replace wbho = 4 if (3 <= perace & perace <= 4)
	replace wbho = 3 if (1 <= prorigin & prorigin <= 7)
}
if tm(2003m1) <= `date' & `date' <= tm(2012m4) {
	* May 2004- June 2005: ptdtrace variable renamed to prdtrace
	if tm(2004m5) <= `date' & `date' <= tm(2005m7) {
		gen ptdtrace = prdtrace
	}
	replace wbho=1 if ptdtrace==1
	replace wbho=2 if ptdtrace==2
	replace wbho=2 if ptdtrace==6 /* black-white */ | ptdtrace==10 /*
	*/ /* black-AI */ | ptdtrace==11 /* black-asian */ | ptdtrace==12 /*
	*/ /* black-HP */ | ptdtrace==15 /* W-B-AI */ | ptdtrace==16 /* W-B-A */ /*
	*/ | ptdtrace==19 /* W-B-AI-A */
	replace wbho=4 if (3<=ptdtrace & ptdtrace<=5)
	replace wbho=4 if ptdtrace==7 /* white-AI */ | ptdtrace==8 /*
	*/ /* white-asian */ | ptdtrace==9 /* white-hawaiian */ | ptdtrace==13 /*
	*/ /* AI-asian */ | ptdtrace==14 /* Asian-HP */ | ptdtrace==17 /* W-AI-A */ /*
	*/ | ptdtrace==18 /* W-A-HP */ | ptdtrace==20 /* 2 or 3 races */ /*
	*/ | ptdtrace==21 /* 4 or 5 races */
	replace wbho=3 if (1<=prdthsp & prdthsp<=5) /* hispanic */
}
if tm(2012m5) <= `date' & `date' <= tm(2013m12) {
	replace wbho=1 if ptdtrace==1 /* white */
	replace wbho=2 if ptdtrace==2 /* black */
	replace wbho=2 if ptdtrace==6 /* black-white */ | ptdtrace==10 /*
	*/ /* black-AI */ | ptdtrace==11 /* black-asian */ | ptdtrace==12 /*
	*/ /* black-HP */ | ptdtrace==16 /* W-B-AI */ | ptdtrace==17 /* W-B-A */ /*
	*/ | ptdtrace==18 /* W-B-HP */ | ptdtrace==22 /* B-AI-A */ /*
	*/ | ptdtrace==23 /* W-B-AI-A */
	replace wbho=4 if (3<=ptdtrace & ptdtrace<=5)
	replace wbho=4 if ptdtrace==7 /* white-AI */ | ptdtrace==8 /*
	*/ /* white-asian */ | ptdtrace==9 /* white-hawaiian */ | ptdtrace==13 /*
	*/ /* AI-asian */ | ptdtrace==14 /* AI-HP */ | ptdtrace==15 /* Asian-HP */ /*
	*/ | ptdtrace==19 /* W-AI-A */ | ptdtrace==20 /* W-AI-HP */ /*
	*/ | ptdtrace==21 /* W-A-HP */ | ptdtrace==24 /* W-AI-A-HP */ /*
	*/ | ptdtrace==25 /* Other 3 races */ | ptdtrace==26 /* 4 and 5 races */
	replace wbho=3 if (1<=prdthsp & prdthsp<=5) /* hispanic */
}
if tm(2014m1) <= `date' & `date' <= tm(2018m5) {
	replace wbho=1 if ptdtrace==1 /* white */
	replace wbho=2 if ptdtrace==2 /* black */
	replace wbho=2 if ptdtrace==6 /* black-white */ | ptdtrace==10 /*
	*/ /* black-AI */ | ptdtrace==11 /* black-asian */ | ptdtrace==12 /*
	*/ /* black-HP */ | ptdtrace==16 /* W-B-AI */ | ptdtrace==17 /* W-B-A */ /*
	*/ | ptdtrace==18 /* W-B-HP */ | ptdtrace==22 /* B-AI-A */ /*
	*/ | ptdtrace==23 /* W-B-AI-A */
	replace wbho=4 if (3<=ptdtrace & ptdtrace<=5)
	replace wbho=4 if ptdtrace==7 /* white-AI */ | ptdtrace==8 /*
	*/ /* white-asian */ | ptdtrace==9 /* white-hawaiian */ | ptdtrace==13 /*
	*/ /* AI-asian */ | ptdtrace==14 /* AI-HP */ | ptdtrace==15 /* Asian-HP */ /*
	*/ | ptdtrace==19 /* W-AI-A */ | ptdtrace==20 /* W-AI-HP */ /*
	*/ | ptdtrace==21 /* W-A-HP */ | ptdtrace==24 /* W-AI-A-HP */ /*
	*/ | ptdtrace==25 /* Other 3 races */ | ptdtrace==26 /* 4 and 5 races */
	replace wbho=3 if (1<=prdthsp & prdthsp<=8) /* hispanic */
}
lab var wbho "Race"
#delimit ;
lab define wbho
1 "White"
2 "Black"
3 "Hispanic"
4 "Other";
#delimit cr
lab val wbho wbho
notes wbho: Racial and ethnic categories are mutually exclusive
notes wbho: Major recoding of race variable in 2003
notes wbho: From 2003, black includes all respondents listing black; other /*
*/ includes all respondents listing non-white or non-black races, except /*
*/ those also listing black
notes wbho: 1973-1988 Unicon: race, spneth
notes wbho: 1989-1993 Unicon: race, spneth
notes wbho: 1994-2002 CPS: perace, prorigin
notes wbho: 2003-2004m4 CPS: ptdtrace, prdthsp
notes wbho: 2004m5-2005m7 CPS: prdtrace, prdthsp
notes wbho: 2005m8-present CPS: ptdtrace, prdthsp
