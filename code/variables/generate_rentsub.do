*******************************************************************************
* Household received government-subsidized rent
*******************************************************************************
gen byte rentsub = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1988m12) {
        replace rentsub = 0 if lowrent == 2
        replace rentsub = 1 if lowrent == 1
        replace rentsub = . if lowrent == 0
    }
    *check starting year (1988B or 1989?)
	if tm(1989m1) <= $date {
		replace rentsub = 0 if hlorent == 2
        replace rentsub = 1 if hlorent == 1
        replace rentsub = . if hlorent == 0
	}    
}

lab var rentsub "Receives government-subsidized rent"
lab def rentsub 1 "Receives rent subsidy" 0 "Does not recieve rent subsidy"
lab val rentsub rentsub
notes rentsub: Available 1976-present
notes rentsub: 1976-present universe: Households not buying and do not own their own, but don't live in public housing, pubhouse == 0
notes rentsub: 1976-1988 Unicon: lowrent
notes rentsub: 1989-1997 Unicon: hlorent
notes rentsub: 1998-present CPS: hlorent
