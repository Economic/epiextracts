********************************************************************************
* mind03: Major industry recode, 2003-present
********************************************************************************
gen byte mind03 = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(2003m1) <= $date {
		replace mind03 = prmjind1
	}
	replace mind03 = . if mind03 < 0
}

if $marchcps == 1 {
	if tm(2003m1) <= $date {
		replace mind03 = a_mjind 
	}
	replace mind03 = . if mind03 < 0
}

#delimit ;
label define mind03
1	 "Agriculture, forestry, fishing, and hunting"
2	 "Mining"
3	 "Construction"
4	 "Manufacturing"
5	 "Wholesale and retail trade"
6	 "Transportation and utilities"
7	 "Information"
8	 "Financial activities"
9	 "Professional and business services"
10 "Educational and health services"
11 "Leisure and hospitality"
12 "Other services"
13 "Public administration"
14 "Armed Forces"
;
label values mind03 mind03;
#delimit cr ;
label var mind03 "Major industry recode, 2003-present"
notes mind03: Major industry recode by Census, consistent for 2003-present
notes mind03: Industry codes from primary job
notes mind03: 2003-present CPS basic/may: prmjind1
notes mind03: 2003-present CPS march: a_mjind
