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


*********************************
* Linking variables to raw data *
*********************************
* Unicon linking variable is recnum
* after investigation, using this instead of hhid, lineno, etc. because
* I could not find a way to combine those into a unique combo in any given month
if tm(1976m1) <= `date' & `date' <= tm(1993m12) {
	rename recnum unicon_recnum
	duplicates report unicon_recnum
	assert r(unique_value) == r(N)
	gen byte hrhhid = .
	gen hrsample = ""
	gen hrsersuf = ""
	gen byte huhhnum = .
	gen byte pulineno = .
	gen hrhhid2 = ""
}
if tm(1994m1) <= `date' & `date' <= tm(2004m4) {
	* use already existing hrhhid hrsersuf huhhnum pulineno to uniquely id persons
	duplicates report gestcen hrhhid hrsample hrsersuf huhhnum pulineno
	assert r(unique_value) == r(N)
	gen byte unicon_recnum = .
	gen hrhhid2 = ""
}
if tm(2004m5) <= `date' & `date' <= tm(2017m12) {
	* use already existing hrhhid hrsersuf huhhnum pulineno to uniquely id persons
	duplicates report hrhhid hrhhid2 pulineno
	assert r(unique_value) == r(N)
	gen byte unicon_recnum = .
	gen hrsample = ""
	gen hrsersuf = ""
	gen byte huhhnum = .
}

lab var hrhhid "CPS: Household identifier (Part 1)"
notes hrhhid: 1994-present: CPS household identifier
notes hrhhid: Used for joining EPI extracts to BLS/Census raw data
lab var hrsample "CPS: Household sample identifier"
notes hrsample: 1994-2004m4: CPS household sample
notes hrsample: Used for joining EPI extracts to BLS/Census raw data
lab var hrsersuf "CPS: Household serial suffix"
notes hrsersuf: 1994-2004m4: CPS household serial suffix
notes hrsersuf: Used for joining EPI extracts to BLS/Census raw data
lab var huhhnum "CPS: Household number"
notes huhhnum: 1994-2004m4: CPS household number
notes huhhnum: Used for joining EPI extracts to BLS/Census raw data
lab var hrhhid2 "CPS: Household identifier (Part 2)"
notes hrhhid2: 2004m5-present: CPS household identifier, part 2
notes hrhhid2: Used for joining EPI extracts to BLS/Census raw data
lab var pulineno "CPS: Person line number within household"
notes pulineno: 1994-present: CPS person line number
notes pulineno: Used for joining EPI extracts to BLS/Census raw data
lab var unicon_recnum "Unicon unique person record, 1976-1993"
notes unicon_recnum: 1976-1993: Unicon: recnum
notes unicon_recnum: Used for joining EPI extracts to Unicon data


***************************
* Consistent household id *
***************************
*gen hhid = .
*for 1976-1993, prob not available
*for 1994-2004m4, will need to convert some things to strings, concatenate
*for 2004m5-present, concatenate hrhhid hrhhid2

*************
* person id *
*************
* use pulineno


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
