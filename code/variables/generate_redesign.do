*******************************************************************************
* Included in 2014 ASEC redesign
*******************************************************************************
capture rename redesign oldredesign
gen byte redesign = .

if $marchcps == 1 {  
	if tm(2014m1) <= $date & $date <= tm(2014m12) {
		replace redesign = 1 if oldredesign == 1
		replace redesign = 0 if oldredesign == 0 
	} 
}

lab var redesign "Included in 2014 ASEC redesign"
lab def redesign 1 "Included in redesign" 0 "Not included in redesign"
lab val redesign redesign
notes penincl: Available 1962-present
