********************************************************************************
* married: Married
********************************************************************************
gen byte married = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1993m12) {
		replace married = 0 if 4 <= marstat & marstat <= 5
		replace married = 1 if 1 <= marstat & marstat <= 3
	}
	if tm(1994m1) <= $date {
		replace married = 0 if 4 <= prmarsta & prmarsta <= 7
		replace married = 1 if 1 <= prmarsta & prmarsta <= 3
	}
}

if $marchcps == 1 {
	if tm(1963m1) <= $date & $date <= tm(1967m12) {
		replace married = 0 if 4 <= marstat & marstat <= 7
		replace married = 1 if 1 <= marstat & marstat <= 3
	}
	if tm(1968m1) <= $date & $date <= tm(1975m12) {
		replace married = 0 if marstat == 1 | marstat == 3 | marstat == 6 | marstat == 7
		replace married = 1 if marstat == 2 | marstat == 4 | marstat == 5
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

keep if age >= 15

label var married "Married"
lab def married 0 "Not married" 1 "Married"
lab val married married
notes married: 1973-1993/1997 Unicon: marstat
notes married: 1994-present CPS: prmarsta
notes married: 1998-present March: a_maritl
notes married: definition change in 1989
