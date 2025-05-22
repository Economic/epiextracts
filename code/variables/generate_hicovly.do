*******************************************************************************
* Policyholder of private health insurance last year
*******************************************************************************
gen byte hicovly = .

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(2018m12) {
		replace hicovly = 0 if hiown == 2
        replace hicovly = 1 if hiown == 1
		replace hicovly = . if hiown == 0
	}    
	if tm(2019m1) <= $date {
		replace hicovly = 0 if ownpriv == 2
        replace hicovly = 1 if ownpriv == 1
		replace hicovly = . if ownpriv == 0
	}
}

lab var hicovly "Private health insurance coverage last year"
lab def hicovly 1 "Covered" 0 "Not covered"
lab val hicovly hicovly
notes hicovly: Available 1980-present
notes hicovly: 1980-present universe: All persons (not infants born after calendar year)
notes hicovly: 1980-1997 Unicon: hiown
notes hicovly: 1997-2018 CPS: hiown
notes hicovly: 2019-present CPS: now_ownpriv
