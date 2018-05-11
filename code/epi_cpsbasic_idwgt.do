local date = `1'



***************************
* Calendar interview year *
***************************
cap drop year
gen int year = year(dofm(`date'))
lab var year "Year"
notes year: Generated from file date



****************************
* Calendar interview month *
****************************
* we could use hrmonth in CPS data
* however, according to unicon, there are values of 68,78,88 in 1978
* so instead we simply just use the month of the file
cap drop month
gen byte month = .
replace month = month(dofm(`date'))
lab var month "Month"
notes month: Generated from file date



*******************
* Month in sample *
*******************
gen byte minsamp = .
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace minsamp = hrmis
	replace minsamp = . if hrmis < 1
}
lab var minsamp "Month in sample"
notes minsamp: CPS: hrmis



**************
* ORG weight *
**************
gen orgwgt = .
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace orgwgt = pworwgt
	replace orgwgt = . if pworwgt <= 0
}
lab var orgwgt "Earnings weight"
notes orgwgt: Only for information collected only in ORG
notes orgwgt: Sum to civilian, non-institutional population in each month
notes orgwgt: To obtain approximate US population with full year of data, /*
*/ divide orgwgt by 12
notes orgwgt: CPS: pworwgt
