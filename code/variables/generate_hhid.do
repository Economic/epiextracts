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

lab var hhid "Household identifer (unique within month)"
notes hhid: Household ID unique within year and month
notes hhid: 1984-1993: derived from year month hrhhid
notes hhid: 1994-1997: derived from year month statefips hrhhid huhhnum hrsample hrsersuf
notes hhid: 1998-present: CPS qstnum
