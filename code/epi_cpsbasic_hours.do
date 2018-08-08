local date = `1'


*******************************************************************************
* Part-time for economic reasons
*******************************************************************************
gen byte ptecon = .
if tm(1989m1) <= `date' & `date' <= tm(1993m12) {
	replace ptecon = 0 if 2 <= wkstat & wkstat <= 5
	replace ptecon = 1 if wkstat == 3 | wkstat == 5
}
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace ptecon = 0 if 2 <= prwkstat & prwkstat <= 10
	replace ptecon = 1 if prwkstat == 3 | prwkstat == 6
}
lab var ptecon "Part-time for economic reasons"
lab def ptecon 1 "Part-time for economic reasons" 0 "Different work status"
lab val ptecon ptecon
notes ptecon: Only available 1989-present
notes ptecon: Universe = those usually FT or usually PT
notes ptecon: Definition/universe change 1989-1993, 1994-present
notes ptecon: 1989-1993 Unicon: wkstat
notes ptecon: 1994-present CPS: prwkstat


/*
variables to create:


*/

*******************************************************************************
* Usual hours worked per week, main job (May supplement)
*******************************************************************************
gen byte hoursumay = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= `date' & `date' <= tm(1981m12) {
		replace hoursumay = wkhrswk
	}
}
replace hoursumay = . if hoursumay < 0
lab var hoursumay "Usual hours worked per week at main job (May supplement)"
lab def hoursumay 99 "99+"
lab val hoursumay hoursumay
notes hoursumay: Only available for May supplement
notes hoursumay: 1973-1981 Unicon: wkhrswk

*******************************************************************************
* Usual hours worked per week, earner study
*******************************************************************************
gen int hoursuorg = .
if $earnerinfo == 1 {
	if tm(1979m1) <= `date' & `date' <= tm(1993m12) {
		replace hoursuorg = ernush
	}
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
		replace hoursuorg = peernhro
	}
}
replace hoursuorg = . if hoursuorg < 0
lab var hoursuorg "Usual hours worked per week at this rate/job (earner study)"
lab def hoursuorg 99 "99+"
lab val hoursuorg hoursuorg
notes hoursuorg: Only available for earner study (ORG + May)
notes hoursuorg: 1994-present CPS: peernhro


*******************************************************************************
* Usual hours worked per week, primary job
*******************************************************************************
gen int hoursu1 = .
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace hoursu1 = pehrusl1
}
replace hoursu1 = . if hoursu1 < 0
lab var hoursu1 "Usual hours worked per week, main job"
lab def hoursu1 99 "99+"
lab val hoursu1 hoursu1

notes hoursu1: Only available 1994-present
notes hoursu1: 1994-present CPS: pehrusl1


*******************************************************************************
* Usual hours worked per week, other jobs
*******************************************************************************
gen int hoursu2 = .
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace hoursu2 = pehrusl2
}
replace hoursu2 = . if hoursu2 < 0
lab var hoursu2 "Usual hours worked per week, main job"
lab def hoursu2 99 "99+"
lab val hoursu2 hoursu2

notes hoursu2: Only available 1994-present
notes hoursu2: 1994-present CPS: pehrusl2


*******************************************************************************
* Usual hours worked per week, all jobs
*******************************************************************************
gen int hoursut = .
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace hoursut = pehruslt
}
replace hoursut = . if hoursut < 0
lab var hoursut "Usual hours worked per week, all jobs"
lab def hoursut 198 "198+"
lab val hoursut hoursut

notes hoursut: Only available 1994-present
notes hoursut: 1994-present CPS: pehruslt


*******************************************************************************
* Hours worked last week, primary job
*******************************************************************************
gen int hourslw1 = .
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace hourslw1 = pehract1
}
replace hourslw1 = . if hourslw1 < 0
lab var hourslw1 "Hours worked last week, main job"
lab def hourslw1 99 "99+"
lab val hourslw1 hourslw1

notes hourslw1: Only available 1994-present
notes hourslw1: 1994-present CPS: pehract1


*******************************************************************************
* Hours worked last week, other jobs
*******************************************************************************
gen int hourslw2 = .
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace hourslw2 = pehract2
}
replace hourslw2 = . if hourslw2 < 0
lab var hourslw2 "Hours worked last week, main job"
lab def hourslw2 99 "99+"
lab val hourslw2 hourslw2

notes hourslw2: Only available 1994-present
notes hourslw2: 1994-present CPS: pehract2


*******************************************************************************
* Hours worked last week, all jobs
*******************************************************************************
gen int hourslwt = .
if tm(1973m1) <= `date' & `date' <= tm(1993m12) {
	replace hourslwt = hours
}
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace hourslwt = pehractt
}
replace hourslwt = . if hourslwt < 0
lab var hourslwt "Hours worked last week, main job"
lab val hourslwt hourslwt

notes hourslwt: Universe/definition changes 1973-1988, 1989-1993, 1994-present
notes hourslwt: Top-coding inconsistent across time
notes hourslwt: Top-code 1973-1993: 99
notes hourslwt: Top-code 1994-present: 198
notes hourslwt: 1973-1993 Unicon: hours
notes hourslwt: 1994-present CPS: pehractt


*******************************************************************************
* Hours vary, primary job
*******************************************************************************
gen byte hoursvary = .
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace hoursvary = 1 if pehrusl1 == -4
}
lab var hoursvary "Usual hours vary, main job"
lab def hoursvary 0 "Hours do not vary" 1 "Hours vary"
lab val hoursvary hoursvary
notes hoursvary: Available 1994-present
notes hoursvary: 1994-present CPS: pehrusl1==-4
