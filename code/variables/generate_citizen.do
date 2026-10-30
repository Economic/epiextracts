********************************************************************************
* citizen: Citizen indicator
********************************************************************************
gen byte citizen = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace citizen = 0 if citistat ~= .
		replace citizen = 1 if 1 <= citistat & citistat <= 4
	}
}

if $marchcps == 1 {
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		replace citizen = 0 if citstat == 5
		replace citizen = 1 if 1 <= citstat & citstat <= 4
	}
	if tm(1998m1) <= $date {
		replace citizen = 0 if prcitshp == 5
		replace citizen = 1 if 1 <= prcitshp & prcitshp <= 4
	}
}

label var citizen "US citizen"
lab def citizen 0 "Not a US citizen" 1 "US citizen"
lab val citizen citizen
notes citizen: 1994-present CPS Basic: citistat
notes citizen: 1994-1997 Unicon March: citstat
notes citizen: 1998-present CPS March: prcitshp
