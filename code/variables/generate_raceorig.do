********************************************************************************
* raceorig: minimally recoded race variable
********************************************************************************
gen byte raceorig = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1988m12) {
		replace raceorig = 1 if race == 1 /* White */
		replace raceorig = 2 if race == 2 /* Black */
		replace raceorig = 0 if race == 3 /* Other */
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace raceorig = 1 if race == 1 /* White */
		replace raceorig = 2 if race == 2 /* Black */
		replace raceorig = 3 if race == 3 /* Amer Indian/Alaskan Native */
		replace raceorig = 4 if race == 4 /* Asian/Pacific Islander */
		replace raceorig = 0 if race == 5 /* Other */
	}
	if tm(1994m1) <= $date & $date <= tm(1995m12) {
		replace raceorig = 1 if perace == 1 /* White */
		replace raceorig = 2 if perace == 2 /* Black */
		replace raceorig = 3 if perace == 3 /* Amer Indian/Alaskan Native */
		replace raceorig = 4 if perace == 4 /* Asian/Pacific Islander */
		replace raceorig = 0 if perace == 5 /* Other */
	}
	if tm(1996m1) <= $date & $date <= tm(2002m12) {
		replace raceorig = 1 if perace == 1 /* White */
		replace raceorig = 2 if perace == 2 /* Black */
		replace raceorig = 3 if perace == 3 /* American Indian/Alaskan Native */
		replace raceorig = 4 if perace == 4 /* Asian/Pacific Islander */
	}
	if tm(2003m1) <= $date & $date <= tm(2012m4) {
		* May 2004- June 2005: ptdtrace variable renamed to prdtrace
		if tm(2004m5) <= $date & $date <= tm(2005m7) {
			*ptdtrace will exist due to generate_wbho.do. else:
			*gen ptdtrace = prdtrace
		}
		replace raceorig = 1 if ptdtrace == 1 /* White */
		replace raceorig = 2 if ptdtrace == 2 /* Black */
		replace raceorig = 3 if ptdtrace == 3 /* American Indian/Alaskan Native */
		replace raceorig = 5 if ptdtrace == 4 /* Asian only */
		replace raceorig = 6 if ptdtrace == 5 /* Hawaiian/Pacific Islander only */
		replace raceorig = 10 if ptdtrace == 6 /* White-Black */
		replace raceorig = 11 if ptdtrace == 7 /* White-AI */
		replace raceorig = 12 if ptdtrace == 8 /* White-Asian */
		replace raceorig = 13 if ptdtrace == 9 /* White-HP */
		replace raceorig = 14 if ptdtrace == 10 /* Black-AI */
		replace raceorig = 15 if ptdtrace == 11 /* Black-Asian */
		replace raceorig = 16 if ptdtrace == 12 /* Black-HP */
		replace raceorig = 17 if ptdtrace == 13 /* AI-Asian */
		replace raceorig = 18 if ptdtrace == 14 /* Asian-HP */
		replace raceorig = 19 if ptdtrace == 15 /* W-B-AI */
		replace raceorig = 20 if ptdtrace == 16 /* W-B-A */
		replace raceorig = 21 if ptdtrace == 17 /* W-AI-A */
		replace raceorig = 22 if ptdtrace == 18 /* W-A-HP */
		replace raceorig = 23 if ptdtrace == 19 /* W-B-AI-A */
		replace raceorig = 30 if ptdtrace == 20 /* 2 or 3 races */
		replace raceorig = 31 if ptdtrace == 21 /* 4 or 5 races */
	}
	if tm(2012m5) <= $date {
		replace raceorig = 1 if ptdtrace == 1 /* White */
		replace raceorig = 2 if ptdtrace == 2 /* Black */
		replace raceorig = 3 if ptdtrace == 3 /* American Indian/Alaskan Native */
		replace raceorig = 5 if ptdtrace == 4 /* Asian only */
		replace raceorig = 6 if ptdtrace == 5 /* Hawaiian/Pacific Islander only */
		replace raceorig = 10 if ptdtrace == 6 /* White-Black */
		replace raceorig = 11 if ptdtrace == 7 /* White-AI */
		replace raceorig = 12 if ptdtrace == 8 /* White-Asian */
		replace raceorig = 13 if ptdtrace == 9 /* White-HP */
		replace raceorig = 14 if ptdtrace == 10 /* Black-AI */
		replace raceorig = 15 if ptdtrace == 11 /* Black-Asian */
		replace raceorig = 16 if ptdtrace == 12 /* Black-HP */
		replace raceorig = 17 if ptdtrace == 13 /* AI-Asian */
		replace raceorig = 18 if ptdtrace == 15 /* Asian-HP */
		replace raceorig = 19 if ptdtrace == 16 /* W-B-AI */
		replace raceorig = 20 if ptdtrace == 17 /* W-B-A */
		replace raceorig = 21 if ptdtrace == 19 /* W-AI-A */
		replace raceorig = 22 if ptdtrace == 21 /* W-A-HP */
		replace raceorig = 23 if ptdtrace == 23 /* W-B-AI-A */
		replace raceorig = 24 if ptdtrace == 14 /* AI-HP */
		replace raceorig = 25 if ptdtrace == 18 /* W-B-HP */
		replace raceorig = 26 if ptdtrace == 20 /* W-AI-HP */
		replace raceorig = 27 if ptdtrace == 22 /* B-AI-A */
		replace raceorig = 28 if ptdtrace == 24 /* W-AI-A-HP */
		replace raceorig = 30 if ptdtrace == 25 /* Other 2 or 3 races */
		replace raceorig = 31 if ptdtrace == 26 /* Other 4 or 5 races */
	}
}

lab var raceorig "Race, minimally recoded, detailed"
#delimit ;
lab define raceorig
0 "Other"
1 "White"
2 "Black"
3 "American Indian/Alaskan Native only"
4 "Asian/Pacific Islander"
5 "Asian only"
6 "Hawaiian/Pacific Islander only"
10 "White-Black"
11 "White-AI"
12 "White-Asian"
13 "White-HP"
14 "Black-AI"
15 "Black-Asian"
16 "Black-HP"
17 "AI-Asian"
18 "Asian-HP"
19 "W-B-AI"
20 "W-B-A"
21 "W-AI-A"
22 "W-A-HP"
23 "W-B-AI-A"
24 "AI-HP"
25 "W-B-HP"
26 "W-AI-HP"
27 "B-AI-A"
28 "W-AI-A-HP"
30 "Other 2 or 3 races"
31 "Other 4 or 5 races"
;
#delimit cr
lab val raceorig raceorig
notes raceorig: minimally recoded original race variable on file (mostly reordering)
notes raceorig: Coding changes in 1989, 1996, 2003, 2012m5
notes raceorig: 1973-1993 Unicon: race
notes raceorig: 1994-2002 CPS: perace
notes raceorig: 2003-present CPS: ptdtrace
