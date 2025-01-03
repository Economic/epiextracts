*******************************************************************************
* Covered by any health insurance last year
*******************************************************************************
gen byte hicov = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(2018m12) {
		replace hicov = 0 if hiown == 2
        replace hicov = 1 if hiown == 1
		replace hicov = . if hiown == 0
	}    
	if tm(2019m1) <= $date {
		replace hicov = 0 if cov == 2
        replace hicov = 1 if cov == 1
		replace hicov = . if cov == 0
	}
}

lab var hicov "Health insurance coverage last year"
lab def hicov 1 "Covered" 0 "Not covered"
lab val hicov hicov
notes hicov: Available 1980-present
notes hicov: 1980-present universe: All persons (not infants born after calendar year)
notes hicov: 1980-1997 Unicon: hiown
notes hicov: 1997-2018 CPS: hiown
notes hicov: 2019-present CPS: cov
