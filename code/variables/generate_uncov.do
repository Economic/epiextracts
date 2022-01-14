*******************************************************************************
* Union coverage
*******************************************************************************
capture rename uncov old_uncov
gen byte uncov = .

if $maycps == 1 {
	if tm(1977m1) <= $date & $date <= tm(1981m12) {
		replace uncov = 0 if old_uncov == 1
		replace uncov = 1 if old_uncov == 0
 	}
}

if $monthlycps == 1 {
	* uncov available in 1983 ORG but not in 1983 Basic
	if $earnerinfo == 1 & $basicfile == 0 {
		if tm(1983m1) <= $date & $date <= tm(1983m12) {
			replace uncov = 0 if old_uncov == 2
			replace uncov = 1 if old_uncov == 1
		}
	}
	if $earnerinfo == 1 & $basicfile == 1 {
		if tm(1984m1) <= $date & $date <= tm(1993m12) {
			replace uncov = 0 if old_uncov == 2
			replace uncov = 1 if old_uncov == 1
		}
		if tm(1994m1) <= $date {
			replace uncov = 0 if peerncov == 2
			replace uncov = 1 if peerncov == 1
		}
	}
}

if $marchcps == 1 {
	if tm(1983m1) <= $date & $date <= tm(1997m12) {
		replace uncov = 0 if old_uncov == 2
		replace uncov = 1 if old_uncov == 1
	}
	if tm(1998m1) <= $date {
		replace uncov = 0 if a_uncov == 2
		replace uncov = 1 if a_uncov == 1
	}
}

lab var uncov "Covered by a union contract (not a member)"
lab def uncov 1 "Union covered" 0 "Not union covered"
lab val uncov uncov
notes uncov: Defined for non-members of unions
notes uncov: Only available in 1977-1981 May, 1983-present ORG
notes uncov: Not available on 1976-1983 basic monthly files
notes uncov: Not available prior to 1977 or in 1982
notes uncov: 1977-1981 Unicon: uncov
notes uncov: 1983-1993/1997 Unicon: uncov
notes uncov: 1994-present CPS basic: peerncov
notes uncov: 1998-present CPS march: a_uncov
