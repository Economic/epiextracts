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
		* NBER dictionaries read pwfmwgt with its 4 implied decimals (%10.4f)
		replace famwgt = pwfmwgt
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

	* population controls used in Census's published series (see asecwgt):
	* 1993 Unicon alternate family weight (1990 Census-based)
	if tm(1993m1) <= $date & $date <= tm(1993m12) {
		replace famwgt = fmwgtalt / 100
	}

	* 1980: Unicon famwgt is one member's weight (the wife in married-couple
	* families, otherwise the head); use that member's alternate weight.
	* Primary and secondary individuals (_famtyp 4, 1) share famid 0 with the
	* primary family but are their own family unit
	if tm(1980m1) <= $date & $date <= tm(1980m12) {
		gen byte famwgt_indiv = inlist(_famtyp, 1, 4)
		gen byte famwgt_match = abs(wgt - oldfamwgt) <= 1 & !famwgt_indiv
		bysort hserial famid famwgt_indiv: egen famwgt_alt = max(cond(famwgt_match, asecwgt, .))
		replace famwgt = famwgt_alt if !missing(famwgt_alt)
		replace famwgt = asecwgt if famwgt_indiv
		drop famwgt_indiv famwgt_match famwgt_alt
	}

	* family weight is the family reference person's asecwgt (unrelated
	* individuals carry their own); rebuild it where the source family weight
	* is inconsistent with asecwgt: 1963 and 1966 asecwgt carry IPUMS scaling
	* factors, 1964 source famwgt is on a different scale, and 2011, 2021 and
	* 2025 asecwgt use revised population controls
	if inlist(year(dofm($date)), 1963, 1964, 1966, 2011, 2021, 2025) {
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
notes famwgt: 2000-2002 CPS Basic: original (1990-based) weight; revised 2000-based person weights have no family/household counterparts
notes famwgt: 1963-1997 Unicon March: famwgt
notes famwgt: 1976 March: asecwgt (for first person in family)
notes famwgt: 1998-present CPS March: fsup_wgt
notes famwgt: 1963, 1964, 1966, 2011, 2021, 2025 March: asecwgt of family reference person (own asecwgt for unrelated individuals)
notes famwgt: 1980 March: wgtalt of the member whose wgt equals Unicon famwgt (own wgtalt for individuals); 1993 March: fmwgtalt
