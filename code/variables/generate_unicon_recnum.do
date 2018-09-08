********************************************************************************
* Unicon record number
********************************************************************************
* Unicon linking variable is recnum
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	rename recnum unicon_recnum
	duplicates report unicon_recnum
	assert r(unique_value) == r(N)
}
if tm(1994m1) <= $date {
  gen byte unicon_recnum = .
}
lab var unicon_recnum "Unicon unique person record, 1973-1993"
notes unicon_recnum: 1973-1993: Unicon: recnum
notes unicon_recnum: Used for joining EPI extracts to Unicon data
