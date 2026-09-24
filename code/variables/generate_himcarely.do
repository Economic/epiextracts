*******************************************************************************
* Medicare coverage last year
*******************************************************************************
gen byte himcarely = .

if $marchcps == 1 {  
	if tm(1980m1) <= $date & $date <= tm(1994m12) {
		replace himcarely = 1 if mcare == 1
		replace himcarely = 0 if mcare == 2
	}
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace himcarely = 1 if mcare == 1 & chmc == 0 
		replace himcarely = 0 if mcare == 2 & chmc == 0
	}
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
		replace himcarely = 1 if mcare == 1 & ch_mc == 0
		replace himcarely = 0 if mcare == 2 & ch_mc == 0
	}
	if tm(2019m1) <= $date {
		replace himcarely = 1 if mcare == 1 & inlist(prpertyp, 2, 3)
		replace himcarely = 0 if mcare == 2 & inlist(prpertyp, 2, 3)
	}
}

lab var himcarely "Medicare coverage last year"
lab def himcarely 1 "Covered" 0 "Not covered
lab val himcarely himcarely
notes himcarely: Available 1980-present
notes himcarely: 1980-present universe: All persons (not infants born after calendar year)
notes himcarely: 1980-1997 Unicon: mcare
notes himcarely: 1998-present CPS: mcare
