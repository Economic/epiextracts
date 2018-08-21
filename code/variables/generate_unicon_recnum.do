********************************************************************************
* Unicon record number
********************************************************************************
* Unicon linking variable is recnum
* after investigation, using this instead of hhid, lineno, etc. because
* I could not find a way to combine those into a unique combo in any given month
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	rename recnum unicon_recnum
	duplicates report unicon_recnum
	assert r(unique_value) == r(N)
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
  gen byte unicon_recnum = .
}
lab var unicon_recnum "Unicon unique person record, 1976-1993"
notes unicon_recnum: 1976-1993: Unicon: recnum
notes unicon_recnum: Used for joining EPI extracts to Unicon data
