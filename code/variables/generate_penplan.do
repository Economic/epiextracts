*******************************************************************************
* Employer-provided pension plan
*******************************************************************************
capture rename penplan orig_penplan
gen byte penplan = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1988m12) {
		replace penplan = 0 if pensplan == 2
        replace penplan = 1 if pensplan == 1
		replace penplan = . if pensplan == 0
	}    
	*check start and end months
	*1988 & 1988B have different underlying vars
	if tm(1989m1) <= $date {
		replace penplan = 0 if orig_penplan == 2
        replace penplan = 1 if orig_penplan == 1
		replace penplan = . if orig_penplan == 0
	} 
}

lab var penplan "Employer-provided pension plan"
lab def penplan 1 "Employer provides pension" 0 "Employer does not provide pension"
lab val penplan penplan
notes penplan: Available 1980-present
notes penplan: 1980-present universe: Those who worked last year
notes penplan: 1980-1988 Unicon: pensplan
notes penplan: 1989-1997 Unicon: penplan
notes penplan: 1998-present CPS: penplan
