*******************************************************************************
* Health insurance coverage last year: original series
*******************************************************************************
* Census's as-published estimates, before the verification question and the
* 2007 and 2011 revisions. Calendar years 1987-1999; 1999 overlaps hicovly3.
gen byte hicovly1 = .

if $marchcps == 1 {
	* 1988-1994 Unicon: includes child Medicaid and private coverage recodes
	if tm(1988m1) <= $date & $date <= tm(1994m12) {
		replace hicovly1 = mcaid == 1 /* medicaid coverage *//*
		*/ | mcare == 1 /* medicare coverage *//*
		*/ | covhi == 1 /* private health insurance *//*
		*/ | champ == 1 /* military/veteran health insurance *//*
		*/ | chmc == 1 /*
		*/ | chhi == 1 | chhi == 2
	}
	* 1995-1997 Unicon
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace hicovly1 = mcaid == 1 | mcare == 1 | covhi == 1 | champ == 1
	}
	* 1998-1999 Census: no revised files overwrite these recodes
	if tm(1998m1) <= $date & $date <= tm(1999m12) {
		replace hicovly1 = mcaid == 1 | mcare == 1 | cov_hi == 1 | champ == 1
	}
	* 2000 Census: as-published recodes saved before the 2011 revision overwrote them
	if tm(2000m1) <= $date & $date <= tm(2000m12) {
		replace hicovly1 = mcaid_orig == 1 | mcare_orig == 1 | cov_hi_orig == 1 | champ_orig == 1
	}
}

lab var hicovly1 "Health insurance coverage last year, original series"
lab def hicovly1 1 "Covered" 0 "Not covered"
lab val hicovly1 hicovly1
notes hicovly1: Available 1988-2000 (calendar years 1987-1999)
notes hicovly1: Census original as-published series; no verification question or 2007/2011 revisions
notes hicovly1: Covered: Medicaid, Medicare, private, or military health care (Census definition)
notes hicovly1: 1988-1994 Unicon: mcaid, mcare, covhi, champ, chmc, chhi
notes hicovly1: 1995-1997 Unicon: mcaid, mcare, covhi, champ
notes hicovly1: 1998-1999 CPS: mcaid, mcare, cov_hi, champ
notes hicovly1: 2000 CPS: mcaid_orig, mcare_orig, cov_hi_orig, champ_orig
