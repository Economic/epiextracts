********************************************************************************
* Household serial ID
********************************************************************************
gen hserial = .

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1962m12) {
		* _hhid is unique by household
		gegen temp_hserial = group(_hhid)
		replace hserial = temp_hserial
		drop temp_hserial
	}
	if tm(1963m1) <= $date & $date <= tm(1967m12) {
		* _hhid is reused for unrelated households in distant parts of the file,
		* so number households sequentially in record order instead
		sort recnum
		gen temp_hserial = sum(_hhid != _hhid[_n-1])
		replace hserial = temp_hserial
		drop temp_hserial
	}
	if tm(1968m1) <= $date & $date <= tm(1975m12) {
		* _hhid is unique by household; a few households have an interleaved
		* record, so group on the value rather than record order

		* 1969-1971: four related subfamily heads sit in their household in
		* record order but carry the previous household's _hhid (and hhid);
		* flag a record between two records of another household, coded as a
		* related subfamily, whose own _hhid has no primary family with
		* subfamilies, and move it to the surrounding household
		sort recnum
		bysort _hhid: egen byte temp_ownsub = max(famdesc == 2)
		sort recnum
		gen byte temp_misid = _hhid != _hhid[_n-1] & _hhid[_n-1] == _hhid[_n+1] /*
			*/ & famdesc == 4 & temp_ownsub == 0 & _n > 1 & _n < _N
		replace hrhhid = hrhhid[_n-1] if temp_misid == 1
		replace _hhid = _hhid[_n-1] if temp_misid == 1
		drop temp_ownsub temp_misid

		gegen temp_hserial = group(_hhid)
		replace hserial = temp_hserial
		drop temp_hserial
	}
	if tm(1976m1) <= $date & $date <= tm(1997m12) {
		replace hserial = hhseq
	}
	if tm(1998m1) <= $date {
		replace hserial = h_seq
	}
}
lab var hserial "ASEC: Household serial number"
notes hserial: Household identifier, unique within year
notes hserial: 1962, 1968-1975 Unicon March: derived from _hhid
notes hserial: 1963-1967 Unicon March: sequential households in record order, derived from _hhid
notes hserial: 1969-1971 Unicon March: four related subfamily heads with the previous household's _hhid are moved to the household they sit in (hrhhid also corrected)
notes hserial: 1976-1997 Unicon March: hhseq
notes hserial: 1998-present CPS March: h_seq
