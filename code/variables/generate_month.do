********************************************************************************
* Calendar interview month
********************************************************************************
* we could use hrmonth in CPS data
* however, according to unicon, there are values of 68,78,88 in 1978
* so instead we simply just use the month of the file
cap drop month
gen byte month = .
replace month = month(dofm($date))
lab var month "Month"
notes month: Generated from file date
