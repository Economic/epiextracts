*******************************************************************************
* Labor force status
*******************************************************************************
gen byte lfstat=.
if tm(1973m1) <= $date & $date <= tm(1988m12) {
	replace lfstat = 1 if 1 <= mlr & mlr <= 2
	replace lfstat = 2 if mlr == 3
	replace lfstat = 3 if 4 <= mlr & mlr <= 7
}
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace lfstat = 1 if 1 <= mlr & mlr <= 2
	replace lfstat = 2 if 3 <= mlr & mlr <= 4
	replace lfstat = 3 if 5 <= mlr & mlr <= 7
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace lfstat = 1 if 1 <= pemlr & pemlr <= 2
	replace lfstat = 2 if 3 <= pemlr & pemlr <= 4
	replace lfstat = 3 if 5 <= pemlr & pemlr <= 7
}
lab var lfstat "Labor-force status"
#delimit ;
lab def lfstat
1 Employed
2 Unemployed
3 NILF
;
#delimit cr
lab val lfstat lfstat
notes lfstat: 1973-1993 Unicon: mlr
notes lfstat: 1994-present CPS: pemlr


*******************************************************************************
* Employed
*******************************************************************************
gen byte emp = 0 if lfstat ~= .
replace emp = 1 if lfstat == 1
lab var emp "Employed"
lab def emp 1 "Employed" 0 "NILF/unemployed"
lab val emp emp
notes emp: Derived from lfstat = 1
notes emp: Universe: lfstat!=.


*******************************************************************************
* Unemployed
*******************************************************************************
gen byte unemp = 0 if lfstat ~= .
replace unemp = 1 if lfstat == 2
lab var unemp "Unemployed"
lab def unemp 1 "Unemployed" 0 "Employed/NILF"
lab val unemp unemp
notes unemp: Derived from lfstat = 2
notes unemp: Universe: lfstat!=.


*******************************************************************************
* Not in labor force
*******************************************************************************
gen byte nilf = 0 if lfstat ~= .
replace nilf = 1 if lfstat == 3
lab var nilf "Not in labor force"
lab def nilf 1 "NILF" 0 "Employed/unemployed"
lab val nilf nilf
notes nilf: Derived from lfstat = 3
notes nilf: Universe: lfstat!=.


*******************************************************************************
* Self-employed (unincorporated)
*******************************************************************************
gen byte selfemp = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace selfemp = 0 if class4 >= 1 & class4 != .
		replace selfemp = 1 if class4 == 3
	}
}
if $monthlycps == 1 & $maycps == 0 {
	if tm(1976m1) <= $date & $date <= tm(1978m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 3
	}
	if tm(1979m1) <= $date & $date <= tm(1988m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 3
	}
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace selfemp = 0 if class >= 1 & class != .
		replace selfemp = 1 if class == 6
	}
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
		replace selfemp = 0 if peio1cow >= 1 & peio1cow != .
		replace selfemp = 1 if peio1cow == 7
	}
}
lab var selfemp "Self-employed (unincorporated)"
lab def selfemp 1 "Self-employed" 0 "Not self-employed"
lab val selfemp selfemp
notes selfemp: Unincorporated self-employed only
notes selfemp: 1994-present CPS: peio1cow
notes selfemp: 1994-present: For first job
notes selfemp: 1976-1993 Unicon Basic: class
notes selfemp: 1973-1981 Unicon May: class4
notes selfemp: Universe: Class of worker assigned (not necessarily employed)
notes selfemp: Different definitions/universes: 1973-1988, 1989-1993, 1994-present


*******************************************************************************
* Incorporated self-employed
*******************************************************************************
gen byte selfinc = .
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace selfinc = 0 if class >= 1 & class != .
	replace selfinc = 1 if class == 5
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace selfinc = 0 if peio1cow >= 1 & peio1cow != .
	replace selfinc = 1 if peio1cow == 6
}
lab var selfinc "Incorporated self-employed"
lab def selfinc 1 "Self-employed (incorp)" 0 "Not self-employed (incorp)"
lab val selfinc selfinc
notes selfinc: Incorporated self-employed only
notes selfinc: 1994-present CPS: peio1cow
notes selfinc: 1994-present: For first job
notes selfinc: 1989-1993 Unicon: derived from class
notes selfinc: Universe: Class of worker assigned (not necessarily employed)
notes selfinc: Different definitions/universes: 1989-1993, 1994-present


*******************************************************************************
* Detailed class of worker, job 1
*******************************************************************************
gen byte cow1 = .
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace cow1 = peio1cow
	replace cow1 = . if peio1cow <= 0
}
lab var cow1 "Class of Worker, 1st job"
#delimit ;
lab def cow1
1 "Government - Federal"
2 "Government - State"
3 "Government - Local"
4 "Private, for profit"
5 "Private, nonprofit"
6 "Self-employed, incorporated"
7 "Self-employed, unincorporated"
8 "Without pay"
;
#delimit cr
lab val cow1 cow1
notes cow1: Available 1994-present
notes cow1: 1994-present CPS: peio1cow


*******************************************************************************
* Detailed class of worker, job 2
*******************************************************************************
gen byte cow2 = .
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace cow2 = peio2cow
	replace cow2 = . if peio2cow <= 0
}
lab var cow2 "Class of Worker, 2nd job"
#delimit ;
lab def cow2
1 "Government - Federal"
2 "Government - State"
3 "Government - Local"
4 "Private, for profit"
5 "Private, nonprofit"
6 "Self-employed, incorporated"
7 "Self-employed, unincorporated"
8 "Without pay"
;
#delimit cr
lab val cow2 cow2
notes cow2: Available 1994-present
notes cow2: 1994-present CPS: peio2cow


*******************************************************************************
* Union membership
*******************************************************************************
capture rename unmem old_unmem
gen byte unmem = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace unmem = 0 if old_unmem == 1
		replace unmem = 1 if old_unmem == 0
 	}
}
if $monthlycps == 1 & $maycps == 0 {
	if tm(1983m1) <= $date & $date <= tm(1993m12) {
		replace unmem = 0 if old_unmem == 2
		replace unmem = 1 if old_unmem == 1
	}
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
		replace unmem = 0 if peernlab == 2
		replace unmem = 1 if peernlab == 1
	}
}
lab var unmem "Member of a union"
lab def unmem 1 "Union member" 0 "Not a union member"
lab val unmem unmem
notes unmem: Only available in 1973-1981 May, 1983-present ORG
notes unmem: Not available in 1982
notes unmem: 1973-1981 Unicon: unmem
notes unmem: 1983-1993 Unicon: unmem
notes unmem: 1994-present CPS: peernlab


*******************************************************************************
* Union coverage
*******************************************************************************
capture rename uncov old_uncov
gen byte uncov = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1977m1) <= $date & $date <= tm(1981m12) {
		replace uncov = 0 if old_uncov == 1
		replace uncov = 1 if old_uncov == 0
 	}
}
if $monthlycps == 1 & $maycps == 0 {
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
		if tm(1994m1) <= $date & $date <= tm(2018m5) {
			replace uncov = 0 if peerncov == 2
			replace uncov = 1 if peerncov == 1
		}
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
notes uncov: 1983-1993 Unicon: uncov
notes uncov: 1994-present CPS: peerncov


*******************************************************************************
* Union represented: member or covered
*******************************************************************************
gen byte union = .
replace union = 0 if unmem ~= . | uncov ~= .
replace union = 1 if unmem == 1
replace union = 1 if uncov == 1
* recode as missing in may before 1977 because no union coverage available
if $monthlycps == 0 & $maycps == 1 {
	if $date <= tm(1976m12) {
		replace union = .
 	}
}
* recode as missing in basic before 1984 because no union coverage available
if $monthlycps == 1 & $maycps == 0 & $earnerinfo == 1 & $basicfile == 1 {
	if $date <= tm(1984m1) {
		replace union = .
	}
}
* recode as missing in org before 1983 because no union coverage available
if $monthlycps == 1 & $maycps == 0 & $earnerinfo == 1 & $basicfile == 0 {
	if $date <= tm(1983m1) {
		replace union = .
	}
}
lab var union "Represented by a union as a member or covered by contract"
lab def union 1 "Union represented" 0 "Not union represented"
lab val union union
notes union: Not defined when union coverage is missing
notes union: Only available in 1977-1981 May, 1983-present ORG
notes union: Not available on 1976-1983 basic monthly files
notes union: Not available prior to 1977 or in 1982
notes union: Derived from unmem and uncov


*******************************************************************************
* Enrolled in high school or college last week
*******************************************************************************
gen byte schenrl = .
if tm(1984m1) <= $date & $date <= tm(1993m12) {
	replace schenrl = 0 if schenr == 2
	replace schenrl = 1 if schenr == 1
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace schenrl = 0 if peschenr == 2
	replace schenrl = 1 if peschenr == 1
}
lab var schenrl "Enrolled in high school or college last week"
lab def schenrl 1 "Enrolled" 0 "Not enrolled"
lab val schenrl schenrl
notes schenrl: Available 1993-present
notes schenrl: 1983-2012 universe: ages 16-24
notes schenrl: 2013-present universe: ages 16-54
notes schenrl: 1984-1993 Unicon: schenr
notes schenrl: 1994-present CPS: peschenr


*******************************************************************************
* Same job as last month
*******************************************************************************
gen byte samejob = .
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace samejob = 1 if puiodp1 == 1
	replace samejob = 0 if puiodp1 == 2
}
lab var samejob "Same employer as last month, at main job"
lab def samejob 1 "Same employer" 0 "Not the same employer"
lab val samejob samejob
notes samejob: Available 1994-present
notes samejob: 1994-present CPS: puiodp1


*******************************************************************************
* Public sector
*******************************************************************************
gen byte pubsec = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace pubsec = 0 if class4 >= 1 & class4 ~= .
		replace pubsec = 1 if class4 == 2
	}
}
if $monthlycps == 1 & $maycps == 0 {
	if tm(1976m1) <= $date & $date <= tm(1988m12) {
		replace pubsec = 0 if class >= 1 & class ~= .
		replace pubsec = 1 if class == 2
	}
}
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace pubsec = 0 if class >= 1 & class ~= .
	replace pubsec = 1 if 2 <= class & class <= 4
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace pubsec = 0 if peio1cow >= 1 & peio1cow ~= .
	replace pubsec = 1 if 1 <= peio1cow & peio1cow <= 3
}
lab var pubsec "Public sector employee"
lab def pubsec 1 "In public sector" 0 "Not in public sector"
lab val pubsec pubsec
notes pubsec: Different definitions/universes CPS Basic: 1976-1988, 1989-1993, 1994-present
notes pubsec: Different definitions/universes CPS May: 1973-1981
notes pubsec: 1994-present: For first job only
notes pubsec: 1973-1981 Unicon May: class4
notes pubsec: 1976-1993 Unicon Basic: class
notes pubsec: 1994-present CPS: peio1cow


*******************************************************************************
* Public sector: local
*******************************************************************************
gen byte publoc = .
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace publoc = 0 if class >= 1 & class ~= .
	replace publoc = 1 if class == 4
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace publoc = 0 if peio1cow >= 1 & peio1cow ~= .
	replace publoc = 1 if peio1cow == 3
}
lab var publoc "Local government employee"
lab def publoc 1 "In local government" 0 "Not in local government"
lab val publoc publoc
notes publoc: Different definitions/universes in 1989-1993, 1994-present
notes publoc: 1994-present: For first job only
notes publoc: 1989-1993 Unicon: class
notes publoc: 1994-present CPS: peio1cow


*******************************************************************************
* Public sector: state
*******************************************************************************
gen byte pubst = .
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace pubst = 0 if class >= 1 & class ~= .
	replace pubst = 1 if class == 3
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace pubst = 0 if peio1cow >= 1 & peio1cow ~= .
	replace pubst = 1 if peio1cow == 2
}
lab var pubst "State government employee"
lab def pubst 1 "In state government" 0 "Not in state government"
lab val pubst pubst
notes pubst: Different definitions/universes in 1989-1993, 1994-present
notes pubst: 1994-present: For first job only
notes pubst: 1989-1993 Unicon: class
notes pubst: 1994-present CPS: peio1cow


*******************************************************************************
* Public sector: federal
*******************************************************************************
gen byte pubfed = .
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace pubfed = 0 if class >= 1 & class ~= .
	replace pubfed = 1 if class == 2
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace pubfed = 0 if peio1cow >= 1 & peio1cow ~= .
	replace pubfed = 1 if peio1cow == 1
}
lab var pubfed "Federal government employee"
lab def pubfed 1 "In federal government" 0 "Not in federal government"
lab val pubfed pubfed
notes pubfed: Different definitions/universes in 1989-1993, 1994-present
notes pubfed: 1994-present: For first job only
notes pubfed: 1989-1993 Unicon: class
notes pubfed: 1994-present CPS: peio1cow


*******************************************************************************
* Weeks unemployed, looking and layoff
*******************************************************************************
gen int unempdur = .
lab var unempdur "Unemployment duration, in weeks"
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace unempdur = prunedur if prunedur >= 0 & prunedur ~= .
}
notes unempdur: Only available since 1994
notes unempdur: Top-code inconsistent across time
notes unempdur: Top-code 1994-2011m3: 999; 2011m4-present: 119


*******************************************************************************
* Weeks unemployed, looking
*******************************************************************************
gen int lookdur = .
if tm(1973m1) <= $date & $date <= tm(1993m12) {
	replace lookdur = wksun if wksun >= 0 & wksun ~= .
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace lookdur = pelkdur if pelkdur >= 0 & pelkdur ~= .
}
lab var lookdur "Job seeking duration (weeks)"
notes lookdur: Top-code inconsistent across time
notes lookdur: Top-code 1976-1993: 99; 1994-2011m3: 999; 2011m4-present: 119
notes lookdur: Definition/universe changes: 1973-1988, 1989-1993, 1994-present
notes lookdur: 1973-1993 Unicon: wksun
notes lookdur: 1994-present CPS: pelkdur


*******************************************************************************
* Discouraged worker
*******************************************************************************
gen byte discwork = .
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace discwork = 0
	replace discwork = 1 if dscwk == 1
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace discwork = 0
	replace discwork = 1 if 1 <= prdisc & prdisc <= 2
}
lab var discwork "Discourged worker"
lab def discwork 1 "Discouraged worker" 0 "Not discouraged worker"
lab val discwork discwork
notes discwork: Only available 1989-present
notes discwork: Definition/universe change 1989-1993, 1994-present
notes discwork: 1989-1993 Unicon: dscwk
notes discwork: 1994-present CPS: prdisc


*******************************************************************************
* Multiple job holder
*******************************************************************************
gen byte multjobs = .
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace multjobs = 0 if pemjot == 2
	replace multjobs = 1 if pemjot == 1
}
lab var multjobs "Multiple job holder"
lab def multjobs 1 "Has more than one job" 0 "Does not have more than one job"
lab val multjobs multjobs
notes multjobs: Only available 1994-present
notes multjobs: Universe = employed or unemployed
notes multjobs: 1994-present CPS: pemjot


*******************************************************************************
* Number of jobs
*******************************************************************************
gen byte numjobs = .
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace numjobs = 1 if emp == 1
	replace numjobs = 2 if pemjnum == 2
	replace numjobs = 3 if pemjnum == 3
	replace numjobs = 4 if pemjnum == 4
}
lab var numjobs "Number of jobs"
lab def numjobs 1 "Employed with one job" 2 "Two jobs" 3 "Three jobs" 4 "Four or more jobs"
lab val numjobs numjobs
notes numjobs: Only available 1994-present
notes numjobs: Universe = employed for one job, labor force for 2+ numjobs
notes numjobs: Top-code: 4 = four or more jobs
notes numjobs: 1994-present CPS: pemjnum
