*******************************************************************************
* Household Medicaid coverage
*******************************************************************************
gen byte medicaidcov = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace medicaidcov = 0 if hmcaid == 3
        replace medicaidcov = 2 if hmcaid == 2 
        replace medicaidcov = 1 hmcaid == 1
    }
}

lab var medicaidcov "Covered by Medicaid"
lab def medicaidcov 2 "All household covered" 1 "Some household covered" 0 "Not covered"
lab val medicaidcov medicaidcov
notes medicaidcov: Available 2019-present
notes medicaidcov: 2019-present universe: All households
notes medicaidcov: 2019-present CPS: hmcaid
