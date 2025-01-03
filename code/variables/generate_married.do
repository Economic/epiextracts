********************************************************************************
* married: Married
********************************************************************************
gen byte married = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1988m12) {
		replace married = 0 if 4 <= marstat & marstat <= 5
		replace married = 1 if 1 <= marstat & marstat <= 3
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12){
		replace married = 0 if 4 <= marstat & marstat <= 7
		replace married = 1 if 1 <= marstat & marstat <= 3
	}
	if tm(1994m1) <= $date {
		replace married = 0 if 4 <= prmarsta & prmarsta <= 7
		replace married = 1 if 1 <= prmarsta & prmarsta <= 3
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1962m12) {
		replace married = 1 if  0 <= marstat & marstat <= 2
		replace married = 0 if 3 <= marstat <= 6
	}
	if tm(1963m1) <= $date & $date <= tm(1967m12) {
		replace married = 0 if 4 <= marstat & marstat <= 7
		replace married = 1 if 1 <= marstat & marstat <= 3
	}
	if tm(1968m1) <= $date & $date <= tm(1975m12) {
		replace married = 0 if marstat == 1 | marstat == 3 | 6 <= marstat & marstat <= 7
		replace married = 1 if 2 <= marstat & marstat <= 5
	}
	if tm(1976m1) <= $date & $date <= tm(1987m12) {
		replace married = 0 if 5 <= marstat & marstat <= 8
		replace married = 1 if 1 <= marstat & marstat <= 4
	}
	if tm(1988m1) <= $date & $date <= tm(1997m12) {
		replace married = 0 if 4 <= marstat & marstat <= 7
		replace married = 1 if 1 <= marstat & marstat <= 3
	}
	if tm(1998m1) <= $date {
		replace married = 0 if 4 <= a_maritl & a_maritl <= 7
		replace married = 1 if 1 <= a_maritl & a_maritl <= 3
	}
}

label var married "Married"
lab def married 0 "Not married" 1 "Married"
lab val married married
notes married: 1976-1982 March: Not married includes age < 14
notes married: 1983-1988 March: Not married includes age < 15
notes married: 1973-1993 Unicon May/Basic: marstat
notes married: 1994-present CPS Basic: prmarsta
notes married: 1962-1997 Unicon March: marstat
notes married: 1998-present CPS March: a_maritl
