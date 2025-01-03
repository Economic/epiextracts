*******************************************************************************
* Household tenure
*******************************************************************************
gen byte hhtenure = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace hhtenure = tenure
        replace hhtenure = . if hhtenure == 0
    }
	if tm(1998m1) <= $date {
		replace hhtenure = h_tenure
        replace hhtenure = . if hhtenure == 0
	}    
}

lab var hhtenure "Tenure of household"
lab def hhtenure 1 "Owned or being bought" 2 "Rented" 3 "No cash rent"
lab val hhtenure hhtenure
notes hhtenure: Available 1976-present
notes hhtenure: 1976-present universe: All households
notes hhtenure: 1976-1988 Unicon: tenure
notes hhtenure: 1989-1997 Unicon: h_tenure
notes hhtenure: 1998-present CPS: h_tenure
