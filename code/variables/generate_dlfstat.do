*******************************************************************************
* Detailed labor force status
*******************************************************************************
gen byte dlfstat = .

if $marchcps == 1 {
    if tm(1994m1) <= $date & $date <= tm(1997m12)  {
        replace dlfstat = mlr
        replace dlfstat = . if dlfstat == -1
	}
	if tm(1998m1) <= $date {
        replace dlfstat = pemlr
        replace dlfstat = . if dlfstat == -1
	}
}

if $monthlycps == 1 {
    if tm(1994m1) <= $date {
        replace dlfstat = pemlr
        replace dlfstat = . if dlfstat == -1
    }
}

lab var dlfstat "Labor-force status"
#delimit ;
lab def dlfstat
1 "Employed-at work"
2 "Employed-absent"
3 "Unemployed-on layoff"
4 "Unemployed-looking"
5 "Not in labor force-retired"
6 "Not in labor force-disabled"
7 "Not in labor force-other"
;
#delimit cr
lab val dlfstat dlfstat
notes dlfstat: 1994-1997 Unicon March: mlr
notes dlfstat: 1994/1998-present CPS Basic/March: pemlr
