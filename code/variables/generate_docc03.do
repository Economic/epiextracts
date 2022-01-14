********************************************************************************
* mocc03: Major occupation recode, 2003-present
********************************************************************************
gen byte docc03 = .
if $monthlycps == 1 {
	if tm(2003m1) <= $date {
		replace docc03 = prdtocc1
	}
	replace docc03 = . if docc03 < 0
}

if $marchcps == 1 {
	if tm(2003m1) <= $date {
		replace docc03 = a_dtocc
	}
	replace docc03 = . if docc03 < 0
}

#delimit ;
label define docc03
1  "Management occupations"
2  "Business and financial operations occupations"
3  "Computer and mathematical science occupations"
4  "Architecture and engineering occupations"
5  "Life, physical, and social science occupations"
6  "Community and social service occupations"
7  "Legal occupations"
8  "Education, training, and library occupations"
9  "Arts, design, entertainment, sports, and media occupations"
10 "Healthcare practitioner and technical occupations"
11 "Healthcare support occupations"
12 "Protective service occupations"
13 "Food preparation and serving related occupations"
14 "Building and grounds cleaning and maintenance occupations"
15 "Personal care and service occupations"
16 "Sales and related occupations"
17 "Office and administrative support occupations"
18 "Farming, fishing, and forestry occupations"
19 "Construction and extraction occupations"
20 "Installation, maintenance, and repair occupations"
21 "Production occupations"
22 "Transportation and material moving occupations"
23 "Armed Forces"
;
label values docc03 docc03;
#delimit cr ;
label var docc03 "Detailed occupation recode, 2003-present"
notes docc03: Detailed occupation recode by Census, consistent for 2003-present
notes docc03: Occupation codes from primary job
notes docc03: 2003-present CPS basic: prdtocc1
notes docc03: 2003-present CPS march: a_dtocc
