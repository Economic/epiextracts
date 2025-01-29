*******************************************************************************
* Employer-provided pension plan
*******************************************************************************
capture lab drop penplan
capture rename penplan oldpenplan
gen byte penplan = .

if $marchcps == 1 {  
	if tm(1980m1) <= $date {
		replace penplan = 0 if oldpenplan == 2
        replace penplan = 1 if oldpenplan == 1
		replace penplan = . if oldpenplan == 0
	} 
}

lab var penplan "Employer-provided pension plan"
lab def penplan 1 "Employer provides pension" 0 "Employer does not provide pension"
lab val penplan penplan
notes penplan: Available 1980-present
notes penplan: 1980-present universe: Those who worked last year
notes penplan: 1980-1997 Unicon: penplan
notes penplan: 1998-present CPS: penplan
