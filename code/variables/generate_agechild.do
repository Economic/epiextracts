*******************************************************************************
* Presence of children, by age group
*******************************************************************************
gen byte agechild = .
if tm(1999m11) <= $date {
	replace agechild = prchld if prchld >= 0 & prchld ~= .
}
lab var agechild "Presence of own children, by age group"
#delimit ;
lab def agechild
0 "No own children under 18 years of age"
1 "All own children 0-2 years of age"
2 "All own children 3-5 years of age"
3 "All own children 6-13 years of age"
4 "All own children 14-17 years of age"
5 "Own children 0-2 and 3-5 years of age (none 6-17)"
6 "Own children 0-2 and 6-13 years of age (none 3-5 or 14-17)"
7 "Own children 0-2 and 14-17 years of age (none 3-13)"
8 "Own children 3-5 and 6-13 years of age (none 0-2 or 14-17)"
9 "Own children 3-5 and 14-17 years of age (none 0-2 or 6-13)"
10 "Own children 6-13 and 14-17 years of age (none 0-5)"
11 "Own children 0-2, 3-5, and  6-13 years of age (none 14-17)"
12 "Own children 0-2, 3-5, and 14-17 years of age (none 6-13)"
13 "Own children 0-2, 6-13, and 14-17 years of age (none 3-5)"
14 "Own children 3-5, 6-13, and 14-17 years of age (none 0-2)"
15 "Own children from all age groups"
;
#delimit cr
lab val agechild agechild
notes agechild: Available 1999m11-present
notes agechild: 1999m11-present CPS: prchld
