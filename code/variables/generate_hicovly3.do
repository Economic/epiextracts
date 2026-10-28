*******************************************************************************
* Health insurance coverage last year: HIB series
*******************************************************************************
* Census HIB tables: September 2011 revision to the imputation routine.
* Calendar years 1999-2013; 1999 overlaps hicovly1 and 2013 overlaps hicovly4.
gen byte hicovly3 = .

if $marchcps == 1 {
	* 2000-2010: revised recodes merged over the originals in process_rawmarch;
	* 2011-2013: production files already use the revised imputation
	if tm(2000m1) <= $date & $date <= tm(2013m12) {
		replace hicovly3 = mcaid == 1 /* medicaid coverage *//*
		*/ | mcare == 1 /* medicare coverage *//*
		*/ | cov_hi == 1 /* private health insurance *//*
		*/ | champ == 1 /* military/veteran health insurance */
	}
	* 2014: traditional-questionnaire records only (5/8 sample)
	if tm(2014m1) <= $date & $date <= tm(2014m12) {
		replace hicovly3 = (mcaid == 1 | mcare == 1 | cov_hi == 1 | champ == 1) if redesign == 0
	}
}

lab var hicovly3 "Health insurance coverage last year, HIB series"
lab def hicovly3 1 "Covered" 0 "Not covered"
lab val hicovly3 hicovly3
notes hicovly3: Available 2000-2014 (calendar years 1999-2013)
notes hicovly3: Census HIB series (September 2011 revision); includes verification question
notes hicovly3: Covered: Medicaid, Medicare, private, or military health care (Census definition)
notes hicovly3: 2000 uses 1990-based weights; Census HIB 1999 uses 2000-based weights
notes hicovly3: 2014: traditional-questionnaire records only; for population counts divide the weights by 5/8
notes hicovly3: 2000-2013 CPS: mcaid, mcare, cov_hi, champ
