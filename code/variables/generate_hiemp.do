*******************************************************************************
* Included in employer group health plan
*******************************************************************************
capture rename hiemp orig_hiemp
gen byte hiemp = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1988m12) {
		replace hiemp = 0 if inclingh == 2
        replace hiemp = 1 if inclingh == 1
		replace hiemp = . if inclingh == 0
	}    
	*check start and end months
	*1988 & 1988B have different underlying vars
	if tm(1989m1) <= $date & $date <= tm(2018m12) {
		replace hiemp = 0 if orig_hiemp == 2
        replace hiemp = 1 if orig_hiemp == 1
		replace hiemp = . if orig_hiemp == 0
	} 
	if tm(2019m1) <= $date {
		replace hiemp = 0 if owngrp == 2
        replace hiemp = 1 if owngrp == 1
		replace hiemp = . if owngrp == 0
	}
}

lab var hiemp "Included in employer group health plan"
lab def hiemp 1 "Included in employer group health plan" 0 "Not included in employer group health plan"
lab val hiemp hiemp
notes hiemp: Available 1980-present
notes hiemp: 1980-1987 universe: Those who worked last year
notes hiemp: 1988-present universe: Those who have health insurance in their own name
notes hiemp: 1980-1988 Unicon: inclingh
notes hiemp: 1989-1997 Unicon: hiemp
notes hiemp: 1998-2018 CPS: hiemp
notes hiemp: 2019-present CPS: owngrp
