********************************************************************************
* Family weight
********************************************************************************
capture rename famwgt oldfamwgt
gen famwgt = .

if $monthlycps == 1 {
	if tm(1984m1) <= $date & $date <= tm(1993m12) {
		replace famwgt = oldfamwgt / 100
	}
	if tm(1994m1) <= $date {
		replace famwgt = pwfmwgt / 10000
	}
}

if $marchcps == 1 {
	if tm(1963m1) <= $date & $date <= tm(1997m12) {
		if tm(1976m1) <= $date & $date <= tm(1976m12) {
			egen firstperson = min(perid), by(hserial famid)
			gen famwgt2 = .
			replace famwgt2 = asecwgt if perid == firstperson
			egen famwgt3 = mean(famwgt2), by(hserial famid)
			replace famwgt = famwgt3
			drop firstperson famwgt2 famwgt3
		}
		else {
			replace famwgt = oldfamwgt / 100
		}
	}
	if tm(1998m1) <= $date & $date <= tm(2013m12) {
		replace famwgt = fsup_wgt
	}
	if tm(2014m1) <= $date & $date <= tm(2014m12) {
		replace famwgt = fsup_wgt * (3/8) if redesign == 1
		replace famwgt = fsup_wgt * (5/8) if redesign == 0
	}
	if tm(2015m1) <= $date & $date <= tm(2018m12) {
		replace famwgt = fsup_wgt
	}
	if tm(2019m1) <= $date {
		replace famwgt = fsup_wgt / 100
	}

	* family weight is the family reference person's asecwgt (unrelated
	* individuals carry their own); rebuild it where the source family weight
	* is inconsistent with asecwgt: 1963 and 1966 asecwgt carry IPUMS scaling
	* factors, 1964 source famwgt is on a different scale, and 2010-2011 and
	* 2020-2021 asecwgt use revised population controls
	if inlist(year(dofm($date)), 1963, 1964, 1966, 2010, 2011, 2020, 2021) {
		* record order, to restore it and to identify each family's first person
		gen long famwgt_order = _n

		* source family relationship (EPI famrel is generated later):
		* Unicon famrel 0 = reference person, 4 = not a family member;
		* Census a_famrel 1 = reference person, 0 = not a family member
		if year(dofm($date)) <= 1966 {
			gen byte famwgt_ref = famrel == 0
			gen byte famwgt_unrel = famrel == 4
		}
		else {
			gen byte famwgt_ref = a_famrel == 1
			gen byte famwgt_unrel = a_famrel == 0
		}

		bysort hserial famid: egen famwgt_refper = max(cond(famwgt_ref, asecwgt, .))

		* fallback for families without a reference person: first person's weight
		bysort hserial famid (famwgt_order): gen famwgt_first = asecwgt[1]

		replace famwgt = famwgt_refper
		replace famwgt = famwgt_first if missing(famwgt_refper)
		replace famwgt = asecwgt if famwgt_unrel
		sort famwgt_order
		drop famwgt_ref famwgt_unrel famwgt_refper famwgt_first famwgt_order
	}

	* zero and negative weights are invalid, as for asecwgt
	replace famwgt = . if famwgt <= 0
}

lab var famwgt "Family weight"
notes famwgt: Family weight, based on head of family
notes famwgt: 1984-1993 Unicon Basic: famwgt
notes famwgt: 1994-present CPS Basic: pwfmwgt
notes famwgt: 1963-1997 Unicon March: famwgt
notes famwgt: 1976 March: asecwgt (for first person in family)
notes famwgt: 1998-present CPS March: fsup_wgt
notes famwgt: 1963, 1964, 1966, 2010-2011, 2020-2021 March: asecwgt of family reference person (own asecwgt for unrelated individuals)
