*******************************************************************************
* Reason for unemployment
*******************************************************************************
gen byte whyunemp = .

if $marchcps == 1 {
    if tm(1988m1) <= $date & $date <= tm(1993m12) {
        replace whyunemp = 1 if runemp == 1
        replace whyunemp = 2 if runemp == 2
        replace whyunemp = 4 if runemp == 3
        replace whyunemp = 5 if runemp == 4
        replace whyunemp = 6 if runemp == 5
    }
    if tm(1994m1) <= $date & $date <= tm(1997m12)  {
        replace whyunemp = runtype
        replace whyunemp = . if whyunemp == -1 | whyunemp == 0
	}
	if tm(1998m1) <= $date {
        replace whyunemp = pruntype
        replace whyunemp = . if whyunemp == 0      
	}
    
}

if $monthlycps == 1 {
    if tm(1994m1) <= $date {
        replace whyunemp = pruntype
        replace whyunemp = . if whyunemp == -1
    }
}

lab var whyunemp "Reason for unemployment"
#delimit ;
lab def whyunemp
1 "Job loser/on layoff"
2 "Other job loser"
3 "Temporary job ended"
4 "Job leaver"
5 "Re-entrant"
6 "New entrant"
;
#delimit cr
lab val whyunemp whyunemp
notes whyunemp: 1994-1997 Unicon: runtype
notes whyunemp: 1998-present CPS: pruntype
