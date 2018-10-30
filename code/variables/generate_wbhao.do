********************************************************************************
* Race: WBHAO
********************************************************************************
* follow coding at http://ceprdata.org
gen byte wbhao = .
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace wbhao = 1 if race == 1
	replace wbhao = 2 if race == 2
	replace wbhao = 4 if race == 4
	replace wbhao = 5 if race == 3 | race == 5
	replace wbhao = 3 if (1 <= spneth & spneth <= 7)
}
if tm(1994m1) <= $date & $date <= tm(2002m12) {
	replace wbhao = 1 if perace == 1
	replace wbhao = 2 if perace == 2
	replace wbhao = 4 if perace == 4
	replace wbhao = 5 if perace == 3 | perace == 5
	replace wbhao = 3 if (1 <= prorigin & prorigin <= 7)
}
if tm(2003m1) <= $date & $date <= tm(2012m4) {
	* May 2004- July 2005: ptdtrace variable renamed to prdtrace
	if tm(2004m5) <= $date & $date <= tm(2005m7) {
		gen ptdtrace = prdtrace
	}
	replace wbhao=1 if prdtrace==1 /* white only */
	replace wbhao=2 if prdtrace==2 /* black only */
	replace wbhao=2 if prdtrace==6 /* black-white */ | prdtrace==10 /*
	*/ /* black-AI */ | prdtrace==11 /* black-asian */ | prdtrace==12 /*
	*/ /* black-HP */ | prdtrace==15 /* W-B-AI */ | prdtrace==16 /* W-B-A */ /*
	*/ | prdtrace==19 /* W-B-AI-A */
	replace wbhao=4 if prdtrace==4 | prdtrace==5 /* asian & HP */ /*
	*/ | prdtrace==8 /* white-asian */ | prdtrace==9 /* white-HP */ | prdtrace==13 /*
	*/ /* AI-Asian */ | prdtrace==14 /* asian-HP */ | prdtrace==17 /* W-AI-A */ /*
	*/ | prdtrace==18 /* W-A-HP */
	replace wbhao=5 if prdtrace==3 /* AI only */ | prdtrace==7 /* white-AI */ /*
	*/ | prdtrace==20 /* 2 or 3 races */ | prdtrace==21 /* 4 or 5 races */
	replace wbhao=3 if (1<=prdthsp & prdthsp<=5) /* hispanic */
}
if tm(2012m5) <= $date & $date <= tm(2013m12) {
	replace wbhao=1 if (5<=month & month<=12) & prdtrace==1 /* white only */
  replace wbhao=2 if (5<=month & month<=12) & prdtrace==2 /* black only */
  replace wbhao=2 if (5<=month & month<=12) & (prdtrace==6 /* black-white */ /*
  */ | prdtrace==10 /* B-AI */ | prdtrace==11 /* B-A */ | prdtrace==12 /* B-HP */ /*
  */ | prdtrace==16 /* W-B-AI */ | prdtrace==17 /* W-B-A */ | prdtrace==18 /*
  */ /* W-B-HP */ | prdtrace==22 /* B-AI-A */ | prdtrace==23) /* W-B-AI-A */
  replace wbhao=4 if (5<=month & month<=12) & (prdtrace==4 | prdtrace==5 /*
  */ /* asian & HP */ | prdtrace==8 /* white-asian */ | prdtrace==9 /*
  */ /* white-HP */ | prdtrace==13 /* AI-Asian */ | prdtrace==14 /*AI-HP */ /*
  */ | prdtrace==15 /* asian-HP */ | prdtrace==19 /* W-AI-A */ /*
  */ | prdtrace==20 /* W-AI-HP */ | prdtrace==21 /* W-A-HP */ /*
  */ | prdtrace==24) /* W-AI-A-HP */
  replace wbhao=5 if (5<=month & month<=12) & (prdtrace==3 /* AI only */ /*
  */ | prdtrace==7 /* white-AI */ | prdtrace==25 /* Other 3 races */ /*
  */ | prdtrace==26 )/* Other 4 and 5 races */
  replace wbhao=3 if (5<=month & month<=12) & (1<=prdthsp & prdthsp<=5) /* hisp */
}
if tm(2014m1) <= $date {
	replace wbhao=1 if prdtrace==1 /* white only */
	replace wbhao=2 if prdtrace==2 /* black only */
	replace wbhao=2 if prdtrace==6 /* black-white */ | prdtrace==10 /*
	*/ /* black-AI */ | prdtrace==11 /* black-asian */ | prdtrace==12 /*
	*/ /* black-HP */ | prdtrace==16 /* W-B-AI */ | prdtrace==17 /* W-B-A */ /*
	*/ | prdtrace==18 /* W-B-HP */ | prdtrace==22 /* B-AI-A */ /*
	*/ | prdtrace==23 /* W-B-AI-A */
	replace wbhao=4 if  prdtrace==4 | prdtrace==5 /* asian & hawaiian/pacific islander */ /*
	*/ | prdtrace==8 /* white-asian */ | prdtrace==9 /* white-HP */ | prdtrace==13 /*
	*/ /* AI-Asian */ | prdtrace==14 /*AI-HP */ | prdtrace==15 /* asian-HP */ /*
	*/ | prdtrace==19 /* W-AI-A */ | prdtrace==20 /* W-AI-HP */ /*
	*/ | prdtrace==21 /* W-A-HP */ | prdtrace==24 /* W-AI-A-HP */
	replace wbhao=5 if prdtrace==3 /* AI only */ | prdtrace==7 /* white-AI */ /*
	*/ | prdtrace==25 /* Other 3 races */ | prdtrace==26 /* Other 4 and 5 races */
	replace wbhao=3 if (1<=prdthsp & prdthsp<=8) /* hispanic */
}
lab var wbhao "Race/ethnicity, including Asian"
#delimit ;
lab define wbhao
1 "White"
2 "Black"
3 "Hispanic"
4 "Asian"
5 "Other";
#delimit cr
lab val wbhao wbhao
notes wbhao: Racial and ethnic categories are mutually exclusive
notes wbhao: Asians include Hawaiian/Pacific Islanders
notes wbhao: Available 1989-present; definition changes in 1996, 2003, 2012m5, 2014
notes wbhao: From 2003, black includes all respondents listing black; other /*
*/ includes all respondents listing non-white or non-black races, except /*
*/ those also listing black
notes wbhao: 1989-1993 Unicon: race, spneth
notes wbhao: 1994-2002 CPS: perace, prorigin
notes wbhao: 2003-2004m4 CPS: ptdtrace, prdthsp
notes wbhao: 2004m5-present CPS: prdtrace, prdthsp
