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
if tm(1994m1) <= $date {
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
