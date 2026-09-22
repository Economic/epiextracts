*******************************************************************************
* Medicare coverage last year
*******************************************************************************
gen byte himcarely = .

if $marchcps == 1 {  
	if tm(1988m1) <= $date {
		replace himcarely = 1 if mcare == 1
		replace himcarely = 0 if mcare == 2
	}
}

lab var himcarely "Medicare coverage last year"
lab def himcarely 1 "Covered" 0 "Not covered
lab val himcarely himcarely
notes himcarely: Available 1988-present
notes himcarely: 1988-present universe: All persons (not infants born after calendar year)
notes himcarely: 1988-1997 Unicon: mcare
notes himcarely: 1998-present CPS: mcare
