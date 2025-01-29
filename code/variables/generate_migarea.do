********************************************************************************
* Migration, within area moves
********************************************************************************
gen byte migarea = .

if $marchcps == 1 {
    if tm(1998m1) <= $date & $date <= tm(1997m12) {
        replace migarea = migmtr3
        replace migarea = . if migarea >= 8
    }
    if tm(1998m1) <= $date {
        replace migarea = mig_mtr3
        replace migarea = . if mig_mtr3 >= 8
    }
}

lab var migarea "Migration status"
#delimit ;
lab def migarea
1 "Nonmover"
2 "Same county"
3 "Different county, same state"
4 "Different state, same division"
5 "Different divion, same region"
6 "Different region"
7 "Abroad"
;
#delimit cr;
label value migarea migarea
notes migarea: 1988-1997 Unicon: migmtr3
notes migarea: 1998-present CPS: mig_mtr3