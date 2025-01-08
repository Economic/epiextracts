********************************************************************************
* citizen: Citizen indicator
********************************************************************************
gen byte citizen = .

if $monthlycps == 1 | $marchcps == 1 {
	if tm(1994m1) <= $date {
		replace citizen = 0 if citistat ~= .
		replace citizen = 1 if 1 <= citistat & citistat <= 4
	}
}

label var citizen "US citizen"
lab def citizen 0 "Not a US citizen" 1 "US citizen"
lab val citizen citizen
notes citizen: 1994 - present: derived from citistat
