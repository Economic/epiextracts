*******************************************************************************
* Household living in public housing project
*******************************************************************************
gen byte pubhouse = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace pubhouse = 0 if public == 2
        replace pubhouse = 1 if public == 1
    }
	if tm(1998m1) <= $date {
		replace pubhouse = 0 if hpublic == 2
        replace pubhouse = 1 if hpublic == 1
	}    
}

lab var pubhouse "Living in public housing"
lab def pubhouse 1 "Lives in public housing" 0 "Does not live in public housing"
lab val pubhouse pubhouse
notes pubhouse: Available 1976-present
notes pubhouse: 1976-1988 universe: Households not buying and do not own their own
notes pubhouse: 1988-present: Households renting
notes pubhouse: 1976-1997 Unicon: public
notes pubhouse: 1998-present CPS: hpublic
