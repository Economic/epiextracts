*******************************************************************************
* Health insurance coverage now
*******************************************************************************
gen byte hicov = .

if $marchcps == 1 {   
	if tm(2014m1) <= $date & $date <= tm(2018m12) {
		replace hicov = 0 if now_anycov == 2
        replace hicov = 1 if now_anycov == 1
		replace hicov = . if now_anycov == 0
	}
	if tm(2019m1) <= $date {
		replace hicov = 0 if now_cov == 2
		replace hicov = 1 if now_cov == 1
		replace hicov = . if now_cov == 0
	}
}

lab var hicov "Health insurance coverage now"
lab def hicov 1 "Covered" 0 "Not covered"
lab val hicov hicov
notes hicov: Available 2014-present
notes hicov: 2014-present universe: All persons (not infants born after calendar year)
notes hicov: 2014-2018 CPS Current Coverage: now_anycov
notes hicov: 2019-present CPS ASEC: now_cov
