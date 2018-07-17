local date = `1'


*******************************************************************************
* Labor force status
*******************************************************************************
gen byte lfstat=.
if tm(1973m1) <= `date' & `date' <= tm(1988m12) {
	replace lfstat = 1 if 1 <= mlr & mlr <= 2
	replace lfstat = 2 if mlr == 3
	replace lfstat = 3 if 4 <= mlr & mlr <= 7
}
if tm(1989m1) <= `date' & `date' <= tm(1993m12) {
	replace lfstat = 1 if 1 <= mlr & mlr <= 2
	replace lfstat = 2 if 3 <= mlr & mlr <= 4
	replace lfstat = 3 if 5 <= mlr & mlr <= 7
}
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
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
gen byte selfemp=.
if tm(1989m1) <= `date' & `date' <= tm(1993m12) {
	replace selfemp = 0 if class >= 1 & class != .
	replace selfemp = 1 if class == 6
}
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace selfemp = 0 if peio1cow >= 1 & peio1cow != .
	replace selfemp = 1 if peio1cow == 7
}
lab var selfemp "Self-employed"
lab def selfemp 1 "Self-employed" 0 "Not self-employed"
lab val selfemp selfemp
notes selfemp: Unincorporated self-employed only
notes selfemp: 1994-present CPS: derived from peio1cow
notes selfemp: 1994-present: For first job
notes selfemp: 1989-1993 Unicon: derived from class
notes selfemp: Universe: Class of worker assigned (not necessarily employed)


*******************************************************************************
* Incorporated self-employed
*******************************************************************************
gen byte selfinc=.
if tm(1989m1) <= `date' & `date' <= tm(1993m12) {
	replace selfemp = 0 if class >= 1 & class != .
	replace selfemp = 1 if class == 5
}
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
	replace selfinc = 0 if peio1cow >= 1 & peio1cow != .
	replace selfinc = 1 if peio1cow == 6
}
lab var selfinc "Incorporated self-employed"
lab def selfinc 1 "Self-employed (incorp)" 0 "Not self-employed (incorp)"
lab val selfinc selfinc
notes selfinc: Incorporated self-employed only
notes selfinc: 1994-present CPS: derived from peio1cow
notes selfinc: 1994-present: For first job
notes selfinc: 1989-1993 Unicon: derived from class
notes selfinc: Universe: Class of worker assigned (not necessarily employed)



*******************************************************************************
* Self-employed (unincorporated or incorporated)
*******************************************************************************
gen byte selfany=.
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= `date' & `date' <= tm(1981m12) {
		replace selfany = 0 if class4 >= 1 & class4 != .
		replace selfany = 1 if class4 == 3
	}
}
if $monthlycps == 1 & $maycps == 0 {
	if tm(1976m1) <= `date' & `date' <= tm(1978m12) {
		replace selfany = 0 if class >= 1 & class != .
		replace selfany = 1 if class == 3
	}
	if tm(1979m1) <= `date' & `date' <= tm(1988m12) {
		replace selfany = 0 if class >= 1 & class != .
		replace selfany = 1 if class == 3
	}
	if tm(1989m1) <= `date' & `date' <= tm(1993m12) {
		replace selfany = 0 if class >= 1 & class != .
		replace selfany = 1 if class == 5 | class == 6
	}
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
		replace selfany = 0 if peio1cow >= 1 & peio1cow != .
		replace selfany = 1 if peio1cow == 6 | peio1cow == 7
	}
}
lab var selfany "Self-employed (unincorporated or incorporated)"
lab def selfany 1 "Self-employed (uninc or inc)" 0 "Not self-employed (uninc or inc)"
lab val selfany selfany
notes selfemp: Self-employed: unincorporated or incorporated
notes selfemp: 1994-present CPS: derived from peio1cow
notes selfinc: 1976-1993 Unicon: derived from class
notes selfemp: Universe: Class of worker assigned (not necessarily employed)


*******************************************************************************
* Union membership
*******************************************************************************
capture rename unmem old_unmem
gen byte unmem = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= `date' & `date' <= tm(1981m12) {
		replace unmem = 0 if old_unmem == 1
		replace unmem = 1 if old_unmem == 0
 	}
}
if $monthlycps == 1 & $maycps == 0 {
	if tm(1983m1) <= `date' & `date' <= tm(1993m12) {
		replace unmem = 0 if old_unmem == 2
		replace unmem = 1 if old_unmem == 1
	}
	if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
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
	if tm(1977m1) <= `date' & `date' <= tm(1981m12) {
		replace uncov = 0 if old_uncov == 1
		replace uncov = 1 if old_uncov == 0
 	}
}
if $monthlycps == 1 & $maycps == 0 {
	* uncov available in 1983 ORG but not in 1983 Basic
	if $earnerinfo == 1 & $basicfile == 0 {
		if tm(1983m1) <= `date' & `date' <= tm(1983m12) {
			replace uncov = 0 if old_uncov == 2
			replace uncov = 1 if old_uncov == 1
		}
	}
	if $earnerinfo == 1 & $basicfile == 1 {
		if tm(1984m1) <= `date' & `date' <= tm(1993m12) {
			replace uncov = 0 if old_uncov == 2
			replace uncov = 1 if old_uncov == 1
		}
		if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
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
	if `date' <= tm(1976m12) {
		replace union = .
 	}
}
* recode as missing in basic before 1984 because no union coverage available
if $monthlycps == 1 & $maycps == 0 & $earnerinfo == 1 & $basicfile == 1 {
	if `date' <= tm(1984m1) {
		replace union = .
	}
}
* recode as missing in org before 1983 because no union coverage available
if $monthlycps == 1 & $maycps == 0 & $earnerinfo == 1 & $basicfile == 0 {
	if `date' <= tm(1983m1) {
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
if tm(1984m1) <= `date' & `date' <= tm(1993m12) {
	replace schenrl = 0 if schenr == 2
	replace schenrl = 1 if schenr == 1
}
if tm(1994m1) <= `date' & `date' <= tm(2018m5) {
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
