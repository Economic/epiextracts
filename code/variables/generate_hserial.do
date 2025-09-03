********************************************************************************
* Household serial ID
********************************************************************************
gen hserial = .

if $marchcps == 1 {
	if tm(1976m1) <= $date & $date <= tm(1997m12) {
		replace hserial = hhseq
	}
	if tm(1998m1) <= $date {
		replace hserial = h_seq
	}
}
lab var hserial "ASEC: Household serial suffix"
notes hserial: 1962-1997 Unicon March: hhseq
notes hserial: 1998-present CPS March: h_seq
notes hrsersuf: Used for joining EPI extracts to BLS/Census raw data
