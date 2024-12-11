*******************************************************************************
* Household Medicaid, PCHIP, or other means-tested coverage last year
*******************************************************************************
gen byte medicaidcov = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace medicaidcov = 0 if mcaid == 3
        replace medicaidcov = 2 if mcaid == 2 
        replace medicaidcov = 1 if mcaid == 1
    }
}

lab var medicaidcov "Covered by Medicaid"
lab def medicaidcov 2 "All household covered" 1 "Some household covered" 0 "Not covered"
lab val medicaidcov medicaidcov
notes medicaidcov: Available 2019-present
notes medicaidcov: 2019-present universe: All households
notes medicaidcov: 2019-present CPS: mcaid
