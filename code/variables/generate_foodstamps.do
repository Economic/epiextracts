*******************************************************************************
* Household received food stamps last year
*******************************************************************************
gen byte foodstamps = .

if $marchcps == 1 {
	if tm(1980m1) <= $date {
		replace foodstamps = 0 if hfoodsp == 2
        replace foodstamps = 1 if hfoodsp == 1
		replace foodstamps = . if hfoodsp == 0
	}    
}

lab var foodstamps "Received food stamps last year"
lab def foodstamps 1 "Received food stamps" 0 "Did not receive food stamps"
lab val foodstamps foodstamps
notes foodstamps: Available 1980-present
notes foodstamps: 1980-present universe: All households
notes foodstamps: 1980-1997 Unicon: hfoodsp
notes foodstamps: 1998-present CPS: hfoodsp
