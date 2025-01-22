*******************************************************************************
* Full/part-time work status
*******************************************************************************
gen byte ftptstat = .

if $monthlycps == 1 {
    if tm(1994m1) <= $date {
        replace ftptstat = prwkstat
        replace ftptstat = . if ftptstat <= 0
    }
}
if $marchcps == 1 {
    if tm(1994m1) <= $date & $date <= tm(1997m12) {
        replace ftptstat = rwkstat
        replace ftptstat = . if ftptstat <= 0 
    }
    if tm(1998m1) <= $date {
        replace ftptstat = prwkstat
        replace ftptstat = . if ftptstat <= 0 
    }
}

lab var ftptstat "Full/part-time work status"
#delimit ;
lab def ftptstat
1 "Not in labor force"
2 "FT hours (35+), usually FT"
3 "PT for economic reasons, usually FT"
4 "PT for non-economic reasons, usually FT"
5 "Not at work, usually FT"
6 "PT hrs, usually PT for economic reasons"
7 "PT hrs, usually PT for non-economic reasons"
8 "FT hours, usually PT for economic reasons"
9 "FT hours, usually PT for non-economic"
10 "Not at work, usually part-time"
11 "Unemployed FT"
12 "Unemployed PT"
;
#delimit cr
lab val ftptstat ftptstat
notes ftptstat: 1994-present CPS Basic: prwkstat
notes ftptstat: 1994-1997 Unicon March: rwkstat
notes ftptstat: 1998-present CPS March: prwkstat
