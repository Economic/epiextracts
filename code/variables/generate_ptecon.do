*******************************************************************************
* Part-time for economic reasons
*******************************************************************************
gen byte ptecon = .

if $monthlycps == 1 | $maycps == 1 | $marchcps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace ptecon = 0 if 2 <= wkstat & wkstat <= 5
		replace ptecon = 1 if wkstat == 3 | wkstat == 5
	}
	if tm(1994m1) <= $date {
		replace ptecon = 0 if 2 <= prwkstat & prwkstat <= 10
		replace ptecon = 1 if prwkstat == 3 | prwkstat == 6
	}
}

lab var ptecon "Part-time for economic reasons"
lab def ptecon 1 "Part-time for economic reasons" 0 "Different work status"
lab val ptecon ptecon
notes ptecon: Only available 1989-present
notes ptecon: Universe = those usually FT or usually PT
notes ptecon: Definition/universe change 1989-1993, 1994-present
notes ptecon: 1989-1993 Unicon: wkstat
notes ptecon: 1994-present CPS: prwkstat
