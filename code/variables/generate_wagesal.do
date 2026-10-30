********************************************************************************
* Wage and salary income last year
********************************************************************************
gen wagesal = .

if $marchcps == 1 {
    * Unicon recode: 99999 "not in universe" in 1968-1975 already set to missing
    * (99999 is a valid top-code in 1985-1988, so the raw incwag is not used)
    if tm(1962m1) <= $date & $date <= tm(1997m12) {
        replace wagesal = _incwag
    }
    if tm(1998m1) <= $date {
        replace wagesal = wsal_val
    }

    * universe matches IPUMS INCWAGE: age 14+ before 1980, 15+ after
    * (sources code out-of-universe children as 0 from 1976 on)
    if $date < tm(1980m1) replace wagesal = . if age < 14
    if tm(1980m1) <= $date replace wagesal = . if age < 15
}

lab var wagesal "Wage and salary income"
notes wagesal: Universe: age 14+ for 1962-1979, age 15+ for 1980-present
notes wagesal: 1962-1997 Unicon: _incwag
notes wagesal: 1998-present CPS: wsal_val
