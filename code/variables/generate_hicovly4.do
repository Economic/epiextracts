*******************************************************************************
* Health insurance coverage last year: redesigned questions, legacy processing
*******************************************************************************
* Redesigned health insurance questions run through Census's legacy
* processing system. Calendar years 2013-2017; 2013 overlaps hicovly3 and
* 2017 overlaps hicovly5.
gen byte hicovly4 = .

if $marchcps == 1 {
	* 2014: redesigned-questionnaire records only (3/8 sample)
	if tm(2014m1) <= $date & $date <= tm(2014m12) {
		replace hicovly4 = (mcaid == 1 | mcare == 1 | cov_hi == 1 | champ == 1) if redesign == 1
	}
	if tm(2015m1) <= $date & $date <= tm(2018m12) {
		replace hicovly4 = mcaid == 1 /* medicaid coverage *//*
		*/ | mcare == 1 /* medicare coverage *//*
		*/ | cov_hi == 1 /* private health insurance *//*
		*/ | champ == 1 /* military/veteran health insurance */
	}
}

lab var hicovly4 "Health insurance coverage last year, redesigned questions, legacy processing"
lab def hicovly4 1 "Covered" 0 "Not covered"
lab val hicovly4 hicovly4
notes hicovly4: Available 2014-2018 (calendar years 2013-2017)
notes hicovly4: Redesigned questionnaire processed with Census legacy system
notes hicovly4: Covered: Medicaid, Medicare, private, or military health care (Census definition)
notes hicovly4: 2014: redesigned-questionnaire records only; weights scaled to 3/8 of population
notes hicovly4: 2014-2018 CPS: mcaid, mcare, cov_hi, champ
