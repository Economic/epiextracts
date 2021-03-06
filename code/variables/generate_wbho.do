********************************************************************************
* Race: WBHO
********************************************************************************
gen byte wbho = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1988m12) {
		replace wbho = 1 if race == 1
		replace wbho = 2 if race == 2
		replace wbho = 4 if race == 3
		* Hispanic ethnicity
		replace wbho = 3 if hispanic == 1
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace wbho = 1 if race == 1
		replace wbho = 2 if race == 2
		replace wbho = 4 if (3 <= race & race <= 5)
		* Hispanic ethnicity
		replace wbho = 3 if hispanic == 1
	}
	if tm(1994m1) <= $date & $date <= tm(1995m12) {
		replace wbho = 1 if perace == 1
		replace wbho = 2 if perace == 2
		replace wbho = 4 if (3 <= perace & perace <= 5)
		* Hispanic ethnicity
		replace wbho = 3 if hispanic == 1
	}
	if tm(1996m1) <= $date & $date <= tm(2002m12) {
		replace wbho = 1 if perace == 1
		replace wbho = 2 if perace == 2
		replace wbho = 4 if (3 <= perace & perace <= 4)
		* Hispanic ethnicity
		replace wbho = 3 if hispanic == 1
	}
	if tm(2003m1) <= $date & $date <= tm(2012m4) {
		* May 2004- June 2005: ptdtrace variable renamed to prdtrace
		if tm(2004m5) <= $date & $date <= tm(2005m7) {
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
		* Hispanic ethnicity
		replace wbho = 3 if hispanic == 1
	}
	if tm(2012m5) <= $date {
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
		* Hispanic ethnicity
		replace wbho = 3 if hispanic == 1
	}
}

lab var wbho "Race/ethnicity"
#delimit ;
lab define wbho
1 "White"
2 "Black"
3 "Hispanic"
4 "Other";
#delimit cr
lab val wbho wbho
notes wbho: Racial and ethnic categories are mutually exclusive
notes wbho: Definition breaks in 1989, 1996, 2003, 2012m5, 2014
notes wbho: Major recoding of race variable in 2003
notes wbho: From 2003, black includes all respondents listing black; other /*
*/ includes all respondents listing non-white or non-black races, except /*
*/ those also listing black
notes wbho: 1973-present: Hispanic definition from variable hispanic
notes wbho: 1973-1993 Unicon: race
notes wbho: 1994-2002 CPS: perace
notes wbho: 2003-present CPS: ptdtrace
