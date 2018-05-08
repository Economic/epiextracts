local date = `1'

*******************
* KEY RESTRICTION *
*******************
* only include adult civilians
keep if prpertyp == 2



*******
* Age *
*******
gen int age = .
if tm(1994m1) <= `date' & `date' <= tm(2012m4) {
	replace age = peage
	replace age = . if peage < 0
}
if tm(2012m5) <= `date' & `date' <= tm(2017m12) {
	replace age = prtage
	replace age = . if prtage < 0
}

lab var age "Age"
notes age: CPS, 1994-2012: peage
notes age: CPS, 2013-present: prtage



**********
* Gender *
**********
gen byte female = .
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
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
notes female: CPS: pesex



*************
* Education *
*************
gen byte educ = .
if tm(1979m1) <= `date' & `date' <= tm(1990m12) {
	replace educ=1 if 1<=gradeat & gradeat<=11
	replace educ=1 if gradeat==12 & gradecp==2 /* didn't complete 12th */
	replace educ=2 if gradeat==12 & gradecp==1 /* completed 12th */
	replace educ=3 if 13<=gradeat & gradeat<=15
	replace educ=3 if gradeat==16 & gradecp==2 /* didn't complete college */
	replace educ=4 if gradeat==16 & gradecp==1 /* completed college */
	replace educ=4 if gradeat==17 /* "completed 4 or 5 years college" */
	replace educ=5 if 18<=gradeat & gradeat~=.
}

if tm(1991m1) <= `date' & `date' <= tm(1991m12) {
	replace educ=1 if 1<=adhga & adhga<=11
	replace educ=1 if adhga==12 & adhgc==2 /* didn't complete 12th */
	replace educ=2 if adhga==12 & adhgc==1 /* completed 12th */
	replace educ=3 if 13<=adhga & adhga<=15
	replace educ=3 if adhga==16 & adhgc==2 /* didn't complete college */
	replace educ=4 if adhga==16 & adhgc==1 /* completed college */
	replace educ=4 if adhga==17 /* "completed 4 or 5 years college" */
	replace educ=5 if 18<=adhga & adhga~=.
}

if tm(1992m1) <= `date' & `date' <= tm(1993m12) {
	replace educ=1 if 31<=grade92 & grade92<=37
	replace educ=2 if 38<=grade92 & grade92<=39 /* includes "no diploma" */
	replace educ=3 if 40<=grade92 & grade92<=42
	replace educ=4 if grade92==43
	replace educ=5 if 44<=grade92 & grade92<=46
}

if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace educ=1 if 31<=peeduca & peeduca<=37
	replace educ=2 if 38<=peeduca & peeduca<=39 /* includes "no diploma" */
	replace educ=3 if 40<=peeduca & peeduca<=42
	replace educ=4 if peeduca==43
	replace educ=5 if 44<=peeduca & peeduca<=46
}

lab var educ "Education level"
#delimit ;
lab define educ
1 "LTHS"
2 "HS"
3 "Some college"
4 "College"
5 "Advanced"
;
#delimit cr
lab val educ educ
notes educ: Follows Jaeger (1997) classifications
notes educ: CPS 1979-1990: derived from gradeat, gradecp
notes educ: CPS 1991: derived from adhga
notes educ: CPS 1992-1993: derived from grade92
notes educ: CPS 1994-present: derived from peeduca



********
* Race *
********
gen byte wbho = .
if tm(1994m1) <= `date' & `date' <= tm(2002m12) {
	replace wbho=1 if perace==1
	replace wbho=2 if perace==2
	replace wbho=4 if (3<=perace & perace<=5)
	replace wbho=3 if (1<=prorigin & prorigin<=7)
}
* May 2004- June 2005: ptdtrace variable renamed to prdtrace
if tm(2004m5) <= `date' & `date' <= tm(2005m7) {
	gen ptdtrace = prdtrace
}
if tm(2003m1) <= `date' & `date' <= tm(2012m4) {
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
	/* coding changed May 2012 */
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
if tm(2014m1) <= `date' & `date' <= tm(2017m12) {
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
notes wbho: CPS, 1994m1-2002m12: derived from perace, prorigin
notes wbho: CPS, 2003m1-2004m4: derived from ptdtrace, prdthsp
notes wbho: CPS, 2004m5-2005m7: derived from prdtrace, prdthsp
notes wbho: CPS, 2005m8-present: derived from ptdtrace, prdthsp
