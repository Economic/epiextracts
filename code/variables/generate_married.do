********************************************************************************
* married: Married
********************************************************************************
gen byte married = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1988m12) {
		replace married = 0 if 4 <= marstat & marstat <= 5
		replace married = 1 if 1 <= marstat & marstat <= 3
	}
	if tm(1989m1) <= tm $date & $date <= tm(1993m12){
		replace married = 0 if 4 <= marstat $ marstat <= 7
		replace married = 1 if 1 <= marstat & marstat <= 3
	}
	if tm(1994m1) <= $date {
		replace married = 0 if 4 <= prmarsta & prmarsta <= 7
		replace married = 1 if 1 <= prmarsta & prmarsta <= 3
	}
}

label var married "Married"
lab def married 0 "Not married" 1 "Married"
lab val married married
notes married: 1973-1993 May/Basic: marstat
notes married: 1994-present Basic: prmarsta
