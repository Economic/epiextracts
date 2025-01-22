**********************************************************************************************
* Household coverage by Medicaid, PCHIP, or other means-tested last year (some or all)
**********************************************************************************************
gen byte medicaid = .

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(2018m12) {
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
notes medicaid: Available 1988-present
notes medicaid: 1988-1997 Unicon: hmcaid
notes medicaid: 1998-present CPS: hmcaid
