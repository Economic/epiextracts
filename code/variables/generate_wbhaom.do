********************************************************************************
* Race: WBHAOM
********************************************************************************
* follow coding at http://ceprdata.org
gen byte wbhaom = .

if $monthlycps == 1 {
	if tm(2003m1) <= $date & $date <= tm(2012m4) {
		* May 2004- July 2005: ptdtrace variable renamed to ptdtrace
		if tm(2004m5) <= $date & $date <= tm(2005m7) {
			*ptdtrace will exist due to generate_wbho.do. else:
			*gen ptdtrace = prdtrace
		}
		replace wbhaom = 1 if ptdtrace == 1
		replace wbhaom = 2 if ptdtrace == 2
		replace wbhaom = 4 if ptdtrace == 4 | ptdtrace == 5 /* Asian or HP */
		replace wbhaom = 5 if ptdtrace == 3 /* AI only */
		replace wbhaom = 6 if 6 <= ptdtrace & ptdtrace <= 21 /*multiple*/
		* Hispanic ethnicity
		replace wbhaom = 3 if hispanic == 1
	}
	if tm(2012m5) <= $date {
		replace wbhaom = 1 if ptdtrace == 1
		replace wbhaom = 2 if ptdtrace == 2
		replace wbhaom = 4 if ptdtrace == 4 | ptdtrace==5 /* Asian or HP */
		replace wbhaom = 5 if ptdtrace == 3 /* AI only */
		replace wbhaom = 6 if 6 <= ptdtrace & ptdtrace <= 26 /*multiple*/
		* Hispanic ethnicity
		replace wbhaom = 3 if hispanic == 1
	}
}

if $marchcps == 1 {
	if tm(2003m1) <= $date & $date <= tm(2012m1) {
		replace wbhaom = 1 if prdtrace == 1
		replace wbhaom = 2 if prdtrace == 2
		replace wbhaom = 4 if prdtrace == 4 | prdtrace == 5 /* Asian or HP */
		replace wbhaom = 5 if prdtrace == 3 /* AI only */
		replace wbhaom = 6 if 6 <= prdtrace & prdtrace <= 21 /*multiple*/
		* Hispanic ethnicity
		replace wbhaom = 3 if hispanic == 3
	}
	if tm(2013m1) <= $date {
		replace wbhaom = 1 if prdtrace == 1
		replace wbhaom = 2 if prdtrace == 2
		replace wbhaom = 4 if prdtrace == 4 | prdtrace==5 /* Asian or HP */
		replace wbhaom = 5 if prdtrace == 3 /* AI only */
		replace wbhaom = 6 if 6 <= prdtrace & prdtrace <= 26 /*multiple*/
		* Hispanic ethnicity
		replace wbhaom = 3 if hispanic == 3
	}
}

lab var wbhaom "Race/ethnicity, including Asian and multiple"
#delimit ;
lab define wbhaom
1 "White"
2 "Black"
3 "Hispanic"
4 "Asian"
5 "Native American"
6 "Multiple races";
#delimit cr
lab val wbhaom wbhaom
notes wbhaom: Racial and ethnic categories are mutually exclusive
notes wbhaom: Asians include Hawaiian/Pacific Islanders
notes wbhaom: Available 2003-present; definition changes in 2012m5, 2014
notes wbhaom: Hispanic definition from variable hispanic
notes wbhaom: 2003-present CPS: ptdtrace
