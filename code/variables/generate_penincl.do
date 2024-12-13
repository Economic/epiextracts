*******************************************************************************
* Included in employer-provided pension plan
*******************************************************************************
capture rename penincl orig_penincl
gen byte penincl = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1988m12) {
		replace penincl = 0 if inclinpp == 2
        replace penincl = 1 if inclinpp == 1
		replace penincl = . if inclinpp == 0
	}    
	*check start and end months
	*1988 & 1988B have different underlying vars
	if tm(1989m1) <= $date {
		replace penincl = 0 if orig_penincl == 2
        replace penincl = 1 if orig_penincl == 1
		replace penincl = . if orig_penincl == 0
	} 
}

lab var penincl "Included in employer-provided pension plan"
lab def penincl 1 "Included in pension plan" 0 "Not included in pension plan"
lab val penincl penincl
notes penincl: Available 1980-present
notes penincl: 1980-present universe: Employer-provided pension plan
notes penincl: 1980-1988 Unicon: inclinpp
notes penincl: 1989-1997 Unicon: penincl
notes penincl: 1998-present CPS: penincl