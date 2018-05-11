local date = `1'


**********************
* Labor force status *
**********************
gen byte lfstat=.
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace lfstat = 1 if pemlr == 1 | pemlr == 2
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
notes lfstat: CPS: derived from pemlr


************
* Employed *
************
gen byte emp = 0 if lfstat ~= .
replace emp = 1 if lfstat == 1
lab var emp "Employed"
lab def emp 1 "Employed" 0 "NILF/unemployed"
lab val emp emp
notes emp: Derived from lfstat = 1
notes emp: Universe: lfstat!=.


**************
* Unemployed *
**************
gen byte unemp = 0 if lfstat ~= .
replace unemp = 1 if lfstat == 2
lab var unemp "Unemployed"
lab def unemp 1 "Unemployed" 0 "Employed/NILF"
lab val unemp unemp
notes unemp: Derived from lfstat = 2
notes unemp: Universe: lfstat!=.


**********************
* Not in labor force *
**********************
gen byte nilf = 0 if lfstat ~= .
replace nilf = 1 if lfstat == 3
lab var nilf "Not in labor force"
lab def nilf 1 "NILF" 0 "Employed/unemployed"
lab val nilf nilf
notes nilf: Derived from lfstat = 3
notes nilf: Universe: lfstat!=.


**********************************
* Self-employed (unincorporated) *
**********************************
gen byte selfemp=.
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace selfemp = 0 if peio1cow >= 1 & peio1cow != .
	replace selfemp = 1 if peio1cow == 7
}
lab var selfemp "Self-employed"
lab def selfemp 1 "Self-employed" 0 "Not self-employed"
lab val selfemp selfemp
notes selfemp: Unincorporated self-employed only
notes selfemp: CPS: derived from peio1cow
notes selfemp: Universe: peio1cow >= 1


******************************
* Incorporated self-employed *
******************************
gen byte selfinc=.
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace selfinc = 0 if peio1cow >= 1 & peio1cow != .
	replace selfinc = 1 if peio1cow == 6
}
lab var selfinc "Incorporated self-employed"
lab def selfinc 1 "Self-employed (incorp)" 0 "Not self-employed (incorp)"
lab val selfinc selfinc
notes selfinc: Incorporated self-employed only
notes selfinc: CPS: derived from peio1cow
notes selfinc: Universe: peio1cow >= 1
