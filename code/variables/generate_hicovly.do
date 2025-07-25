*******************************************************************************
* Health insurance coverage last year
*******************************************************************************
gen byte hicovly = .

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(1994m12) {
		replace hicovly = 1 if mcaid == 1 /* medicaid coverage */
		replace hicovly = 1 if mcare == 1 /* medicare coverage */
		replace hicovly = 1 if hiyn == 1 /* private health insurace */
		replace hicovly = 1 if champ == 1 /* miltary/veteran health insurance */
		replace hicovly = 0 if mcaid == 2 
		replace hicovly = 0 if mcare == 2 
		replace hicovly = 0 if hiyn == 2 
		replace hicovly = 0 if champ == 2 
	}
	if tm(1995m1) <= $date & $date <= tm(2018m12) {
		replace hicovly = 1 if mcaid == 1 /* medicaid coverage */
		replace hicovly = 1 if mcare == 1 /* medicare coverage */
		replace hicovly = 1 if hiyn == 1 /* private health insurace */
		replace hicovly = 1 if oth == 1 /* other type of health insurance */
		replace hicovly = 0 if mcaid == 2 
		replace hicovly = 0 if mcare == 2 
		replace hicovly = 0 if hiyn == 2 
		replace hicovly = 0 if oth == 2 
	}    
	if tm(2019m1) <= $date {
		replace hicovly = 0 if cov == 2
        replace hicovly = 1 if cov == 1
		replace hicovly = . if cov == 0
	}
}

lab var hicovly "Health insurance coverage last year"
lab def hicovly 1 "Covered" 0 "Not covered"
lab val hicovly hicovly
notes hicovly: Available 1988-present
notes hicovly: 1988-present universe: All persons (not infants born after calendar year)
notes hicovly: 1988-1994 Unicon: mcaid, mcare, hiyn, champ
notes hicovly: 1995-1997 Unicon: mcaid, mcare, hiyn, oth
notes hicovly: 1997-2018 CPS: mcaid, mcare, hiyn, oth
notes hicovly: 2019-present CPS: cov
