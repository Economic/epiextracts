*******************************************************************************
* Health insurance coverage last year: HIA series
*******************************************************************************
* Census HIA tables: March 2007 correction to coverage of dependents.
* Calendar years 2000-2009. Calendar year 1999 is omitted: Census's HIA value
* includes the verification question, which is not on the 2000 public file.
gen byte hicovly2 = .

if $marchcps == 1 {
	* 2001-2004: as-published recodes plus June 2007 household flags approximating the correction
	if tm(2001m1) <= $date & $date <= tm(2004m12) {
		replace hicovly2 = mcaid_orig == 1 /* medicaid coverage *//*
		*/ | mcare_orig == 1 /* medicare coverage *//*
		*/ | cov_hi_orig == 1 /* private health insurance *//*
		*/ | champ_orig == 1 /* military/veteran health insurance *//*
		*/ | allempl == 1 /* household employer plan covering everyone *//*
		*/ | allpriv == 1 /* household direct-purchase plan covering everyone */
	}
	* 2005-2010: as-published recodes already include the correction
	if tm(2005m1) <= $date & $date <= tm(2010m12) {
		replace hicovly2 = mcaid_orig == 1 | mcare_orig == 1 | cov_hi_orig == 1 | champ_orig == 1
	}
}

lab var hicovly2 "Health insurance coverage last year, HIA series"
lab def hicovly2 1 "Covered" 0 "Not covered"
lab val hicovly2 hicovly2
notes hicovly2: Available 2001-2010 (calendar years 2000-2009)
notes hicovly2: Census HIA series (March 2007 revision); calendar year 1999 not reproducible from public file
notes hicovly2: Covered: Medicaid, Medicare, private, or military health care (Census definition)
notes hicovly2: 2001-2004 CPS: mcaid_orig, mcare_orig, cov_hi_orig, champ_orig, allempl, allpriv
notes hicovly2: 2005-2010 CPS: mcaid_orig, mcare_orig, cov_hi_orig, champ_orig
