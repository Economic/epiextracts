*******************************************************************************
* Household covered by Medicaid last year (some or all)
*******************************************************************************
gen byte medicaid = .

if $marchcps == 1 {
    if tm(1980m1) <= $date & $date <= tm(1988m12) {
        replace medicaid = 0 if covmedcd == 2
        replace medicaid = 1 if covmedcd == 1
    }
    *check starting year (1988B or 1989?)
	if tm(1989m1) <= $date & $date <= tm(1997m12) {
		replace medicaid = 0 if mcaid == 2
        replace medicaid = 1 if mcaid == 1
	}    
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
		replace medicaid = 0 if hmcaid == 2
        replace medicaid = 1 if hmcaid == 1
	} 
    if tm(2019m1) <= $date {
        replace medicaid = 0 if hmcaid == 3
        replace medicaid = 1 if hmcaid == 2 | hmcaid == 1
    }
}

lab var medicaid "Covered by Medicaid"
lab def medicaid 1 "Covered (some or all household)" 0 "Not covered"
lab val medicaid medicaid
notes medicaid: Available 1980-present
notes medicaid: 1980-1988 universe: All persons
notes medicaid: 1988-present: All households
notes medicaid: 1980-1988 Unicon: covmedcd
notes medicaid: 1989-1997 Unicon: mcaid
notes medicaid: 1998-present CPS: hmcaid
