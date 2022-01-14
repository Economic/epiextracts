*******************************************************************************
* Employer/union provided health insurance
*******************************************************************************
capture rename hiemp old_hiemp
gen byte hiemp = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1997m12) {
        replace hiemp = 1 if old_hiemp == 1
        replace hiemp = 0 if old_hiemp == 2 | old_hiemp == 0

	}
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
        replace hiemp = 1 if old_hiemp == 1
        replace hiemp = 0 if old_hiemp == 2 | old_hiemp == 0

	}
    if tm(2019m1) <= $date {
        replace hiemp = 1 if depgrp == 1
        replace hiemp = 0 if depgrp == 2 | depgrp == 0
    }
}

lab var hiemp "Employer/union provided health insurance"
lab def hiemp 1 "Health insurance covered" 0 "Health insurance not covered", replace
lab val hiemp hiemp
notes hiemp: 1980-1997 Unicon: hiemp
notes hiemp: 1997-2018 CPS: hiemp
notes hiemp: 2019-present CPS: depgrp
