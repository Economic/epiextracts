********************************************************************************
* Household ID
********************************************************************************
capture rename hhid oldhhid
gen hhid = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1984m1) <= $date & $date <= tm(1993m12) {
		gegen temp_hhid = group(year month hrhhid)
		replace hhid = temp_hhid
		drop temp_hhid
	}
	if tm(1994m1) <= $date & $date <= tm(1997m12) {
		gegen temp_hhid = group(year month gestfips hrhhid huhhnum hrsample hrsersuf)
		replace hhid = temp_hhid
		drop temp_hhid
	}
	if tm(1998m1) <= $date {
		destring qstnum, replace
		replace hhid = qstnum
	}
}

if $marchcps == 1 {
	* character in underlying variable
	if tm(1962m1) <= $date & $date <= tm(1975m12) {
		gegen temp_hhid = group(year oldhhid)
		replace hhid = temp_hhid
		drop temp_hhid
	}
	if tm(1976m1) <= $date & $date <= tm(1997m12) {
		destring oldhhid, replace
		replace hhid = oldhhid
	}
	if tm(1998m1) <= $date & $date <= tm(2004m12) {
		destring h_idnum, replace
		replace hhid = h_idnum
	}
	if tm(2005m1) <= $date & $date <= tm(2018m12) {
		destring h_idnum1, replace
		replace hhid = h_idnum1
	}
	if tm(2019m1) <= $date {
		destring h_idnum, replace
		replace hhid = h_idnum
	}
}

lab var hhid "Household identifer (unique within month)"
notes hhid: Household ID unique within year and month
notes hhid: 1984-1993: Basic/May derived from year month hrhhid
notes hhid: 1994-1997: Basic/May derived from year month statefips hrhhid huhhnum hrsample hrsersuf
notes hhid: 1998-present: Basic/May qstnum
notes hhid: 1962-1975: March derived from year hhid
notes hhid: 1962-1997 Unicon March: hhid
notes hhid: 1998-2004 CPS March: h_idnum
notes hhid: 2005-2018 CPS March: h_idnum1
notes hhid: 2019-present CPS March: h_idnum
