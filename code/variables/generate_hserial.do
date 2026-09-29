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
notes hserial: 1976-1997 Unicon March: hhseq
notes hserial: 1998-present CPS March: h_seq
