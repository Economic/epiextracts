***************************
* Calendar interview year *
***************************
cap drop year
gen int year = year(dofm($date))
lab var year "Year"
notes year: Generated from file date


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


********************************************************************************
* Linking variables to raw data
********************************************************************************
* Unicon linking variable is recnum
* after investigation, using this instead of hhid, lineno, etc. because
* I could not find a way to combine those into a unique combo in any given month
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	rename recnum unicon_recnum
	duplicates report unicon_recnum
	assert r(unique_value) == r(N)
	gen hrhhid = ""
	gen hrsample = ""
	gen hrsersuf = ""
	gen byte huhhnum = .
	gen byte pulineno = .
	gen hrhhid2 = ""
}
if tm(1994m1) <= $date & $date <= tm(2004m4) {
	* use already existing hrhhid hrsersuf huhhnum pulineno to uniquely id persons
	duplicates report gestcen hrhhid hrsample hrsersuf huhhnum pulineno
	assert r(unique_value) == r(N)
	gen byte unicon_recnum = .
	gen hrhhid2 = ""
}
if tm(2004m5) <= $date & $date <= tm(2018m5) {
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
* use pulineno & recnum?


********************************************************************************
* Month in sample
********************************************************************************
gen byte minsamp = .
if tm(1976m1) <= $date & $date <= tm(1993m12) {
	replace minsamp = mis
	assert minsamp >= 1 & minsamp <= 8
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace minsamp = hrmis
	*replace minsamp = . if hrmis < 1
	assert minsamp >= 1 & minsamp <= 8
}
lab var minsamp "Month in sample"
notes minsamp: CPS: hrmis


********************************************************************************
* ORG weight
********************************************************************************
gen orgwgt = .
if tm(1979m1) <= $date & $date <= tm(1993m12) {
	* to ensure this runs on 1979-1981 basic, when ORG is a separate file
	* and ernwgt is missing in basic
	capture confirm variable ernwgt
	if _rc==0 {
		replace orgwgt = ernwgt / 100
	}
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace orgwgt = pworwgt
}
replace orgwgt = . if orgwgt <= 0
lab var orgwgt "Earnings weight"
notes orgwgt: Only for information collected only in ORG
notes orgwgt: Sum to civilian, non-institutional population in each month
notes orgwgt: To obtain approximate US population with full year of data, /*
*/ divide orgwgt by 12
notes orgwgt: 1994-present CPS: pworwgt
notes orgwgt: 1979-1993 Unicon: ernwgt


********************************************************************************
* Final basic monthly weight
********************************************************************************
gen finalwgt = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace finalwgt = wgtfnl / 100
	}
}
if $monthlycps == 1 & $maycps == 0 {
	if tm(1976m1) <= $date & $date <= tm(1993m12) {
		replace finalwgt = wgt / 100
	}
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace finalwgt = pwsswgt
}
replace finalwgt = . if finalwgt < 0
lab var finalwgt "Final basic monthly weight"
notes finalwgt: Sum to civilian, non-institutional population in each month
notes finalwgt: 1973-1981 Unicon May: wgtfnl
notes finalwgt: 1976-1993 Unicon: wgt
notes finalwgt: 1994-present CPS: pwsswgt


********************************************************************************
* Composite basic monthly weight
********************************************************************************
gen cmpwgt = .
if tm(1998m1) <= $date & $date <= tm(2018m5) {
	replace cmpwgt = pwcmpwgt
}
replace cmpwgt = . if cmpwgt < 0
lab var cmpwgt "Composited final monthly weight"
notes cmpwgt: Available only 1998-present
notes cmpwgt: Sum to civilian, non-institutional population age > 16 in each month
notes cmpwgt: Use to replicate BLS statistics
notes cmpwgt: 1998-present CPS: pwcmpwgt


********************************************************************************
* Basic monthly weight
********************************************************************************
gen basicwgt = .
if tm(1973m1) <= $date & $date <= tm(1997m12) {
	replace basicwgt = finalwgt
}
if tm(1998m1) <= $date & $date <= tm(2018m5) {
	replace basicwgt = cmpwgt
}
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	replace basicwgt = . if age < 16 | age == .
}
if tm(1994m1) <= $date & $date <= tm(2012m4) {
	replace basicwgt = . if peage < 16 | peage == .
}
if tm(2012m5) <= $date & $date <= tm(2018m5) {
	replace basicwgt = . if prtage < 16 | prtage == .
}
lab var basicwgt "Basic monthly weight"
notes basicwgt: Sum to civilian, non-institutional population age > 16 in each month
notes basicwgt: Combination of finalwgt and pwcmpwgt, but defined only for age > 16
notes basicwgt: Used by EPI for most labor force statistics
notes basicwgt: 1973-1997: finalwgt
notes basicwgt: 1998-present: cmpwgt
