********************************************************************************
* mocc03: Major occupation recode, 2003-present
********************************************************************************
gen byte mocc03 = .

if $monthlycps == 1 {
	if tm(2003m1) <= $date {
		replace mocc03 = prmjocc1
	}
	replace mocc03 = . if mocc03 < 0
}

if $marchcps == 1 {
	if tm(2003m1) <= $date & $date <= tm(2010m12) {
		replace mocc03 = mjocc
	}
	if tm(2011m1) <= $date {
		replace mocc03 = a_mjocc
	}
	replace mocc03 = . if mocc03 < 0
}

#delimit ;
label define mocc03
1	 "Management, business, and financial occupations"
2  "Professional and related occupations"
3  "Service occupations"
4  "Sales and related occupations"
5  "Office and administrative support occupations"
6  "Farming, fishing, and forestry occupations"
7  "Construction and extraction occupations"
8  "Installation, maintenance, and repair occupations"
9  "Production occupations"
10 "Transportation and material moving occupations"
11 "Armed Forces"
;
label values mocc03 mocc03;
#delimit cr ;
label var mocc03 "Major occupation recode, 2003-present"
notes mocc03: Major occupation recode by Census, consistent for 2003-present
notes mocc03: Occupation codes from primary job
notes mocc03: 2003-present CPS basic: prmjocc1
notes mocc03: 2003-2011 CPS march: mjocc
notes mocc03: 2011-present CPS march: a_mjocc
