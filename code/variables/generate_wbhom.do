********************************************************************************
* Race: WBHOM
********************************************************************************
* follow coding at http://ceprdata.org
gen byte wbhom = .

if $monthlycps == 1 {
	if tm(2003m1) <= $date & $date <= tm(2012m4) {
		* May 2004- July 2005: ptdtrace variable renamed to ptdtrace
		if tm(2004m5) <= $date & $date <= tm(2005m7) {
			*ptdtrace will exist due to generate_wbho.do. else:
			*gen ptdtrace = prdtrace
		}
		replace wbhom = 1 if ptdtrace == 1
		replace wbhom = 2 if ptdtrace == 2
		replace wbhom = 4 if 3 <= ptdtrace & ptdtrace <= 5
		replace wbhom = 5 if 6 <= ptdtrace & ptdtrace <= 21 /*multiple*/
		replace wbhom = 4 if ptdtrace == 13 /* AI-asian */ | ptdtrace == 14 /* Asian-HP */
		* Hispanic ethnicity
		replace wbhom = 3 if hispanic == 1
	}
	if tm(2012m5) <= $date {
		replace wbhom = 1 if ptdtrace == 1
		replace wbhom = 2 if ptdtrace == 2
		replace wbhom = 4 if 3 <= ptdtrace & ptdtrace <= 5
		replace wbhom = 5 if 6 <= ptdtrace & ptdtrace <= 26 /*multiple*/
		replace wbhom = 4 if ptdtrace == 13 /* AI-asian */ | ptdtrace == 14 /* AI-HP */ /*
	*/ | ptdtrace == 15 /* Asian-HP */
		* Hispanic ethnicity
		replace wbhom = 3 if hispanic == 1
	}
}

lab var wbhom "Race/ethnicity, including multiple"
#delimit ;
lab define wbhom
1 "White"
2 "Black"
3 "Hispanic"
4 "Other"
5 "Multiple races";
#delimit cr
lab val wbhom wbhom
notes wbhom: Racial and ethnic categories are mutually exclusive
notes wbhom: Available 2003-present; definition changes in 2012m5, 2014
notes wbhom: Hispanic definition from variable hispanic
notes wbhom: From 2003, black, white, and other exclude all respondents /*
*/ listing more than one race, except AI-Asian, AI-HP, Asian-HP, which /*
*/ are included in other
notes wbhom: 2003-present CPS: ptdtrace
