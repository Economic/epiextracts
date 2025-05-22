*******************************************************************************
* Included in employer group health plan
*******************************************************************************
capture lab drop hiemp
capture rename hiemp orig_hiemp
gen byte hiemply = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(2018m12) {
		replace hiemply = 0 if orig_hiemp == 2
        replace hiemply = 1 if orig_hiemp == 1
	} 
	if tm(2019m1) <= $date {
		replace hiemply = 0 if owngrp == 2
        replace hiemply = 1 if owngrp == 1
	}
}

lab var hiemply "Included in employer group health plan last year"
lab def hiemply 1 "Included" 0 "Not included"
lab val hiemply hiemply
notes hiemply: Available 1980-present
notes hiemply: 1980-1987 universe: Those who worked last year
notes hiemply: 1988-present universe: Those who have health insurance in their own name
notes hiemply: 1980-1988 Unicon: inclingh
notes hiemply: 1989-1997 Unicon: hiemp
notes hiemply: 1998-2018 CPS: hiemp
notes hiemply: 2019-present CPS: owngrp
