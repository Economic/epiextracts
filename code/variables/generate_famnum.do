*******************************************************************************
* Family number
*******************************************************************************
gen byte famnum = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace famnum = prfamnum
	}
}

lab var famnum "Family number recode"
#delimit ;
lab define famnum
0 "Not a family member"
1 "Primary family member only"
2 "Subfamily no. 2 member"
3 "Subfamily no. 3 member"
4 "Subfamily no. 4 member"
5 "Subfamily no. 5 member"
6 "Subfamily no. 6 member"
7 "Subfamily no. 7 member"
8 "Subfamily no. 8 member"
9 "Subfamily no. 9 member"
10 "Subfamily no. 10 member"
11 "Subfamily no. 11 member"
12 "Subfamily no. 12 member"
13 "Subfamily no. 13 member"
14 "Subfamily no. 14 member"
15 "Subfamily no. 15 member"
16 "Subfamily no. 16 member"
17 "Subfamily no. 17 member"
18 "Subfamily no. 18 member"
19 "Subfamily no. 19 member"
;
#delimit cr
lab val famnum famnum
notes famnum: Census recode of family number
notes famnum: 1994-present CPS: prfamnum
