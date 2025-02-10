*******************************************************************************
* Health insurance coverage last year
*******************************************************************************
gen byte hicovly = .

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(1994m12) {
		replace hicovly = mcaid == 1 /* medicaid coverage *//*
		*/ | mcare == 1 /* medicare coverage *//*
		*/ | hiyn == 1 /* private health insurace *//*
		*/| champ == 1 /* military/veteran health insurance */
		replace hicovly = . if hiyn == 0

	}
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace hicovly = mcaid == 1 /* medicaid coverage *//*
		*/ | mcare == 1 /* medicare coverage *//*
		*/ | hiyn == 1 /* private health insurace *//*
		*/| oth == 1 /* other types of health insurance */
		replace hicovly = . if hiyn == 0
	}
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
		replace hicovly = mcaid == 1 /* medicaid coverage *//*
		*/ | mcare == 1 /* medicare coverage *//*
		*/ | hi_yn == 1 /* private health insurace *//*
		*/| oth == 1 /* other types of health insurance */
		replace hicovly = . if hi_yn == 0
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
notes hicovly: Available 1980 & 1982-present
notes hicovly: 1980 & 1982-present universe: All persons (not infants born after calendar year)
notes hicovly: 1980 & 1982-1994 Unicon: mcaid, mcare, hiyn, champ
notes hicovly: 1995-1997 Unicon: mcaid, mcare, hiyn, oth
notes hicovly: 1998-2018 CPS: mcaid, mcare, hi_yn, oth
notes hicovly: 2019-present CPS: cov
