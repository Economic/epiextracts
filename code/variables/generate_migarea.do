********************************************************************************
* Migration, within area moves
********************************************************************************
gen byte migarea = .

if $marchcps == 1 {
    if tm(1989m1) <= $date & $date <= tm(1994m12) {
        * variable missing for 1995
        if tm(1995m1) <= $date & $date <= tm(1995m12) {
            migarea = .
        }
        else {
            replace migarea = migmtr3
            replace migarea = . if migarea >= 8
        }
        
    }
    if tm(1998m1) <= $date {
        replace migarea = mig_mtr3
        replace migarea = . if mig_mtr3 >= 8
    }
}

lab var migarea "Migration status, area"
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
notes migarea: 1989-1997 Unicon: migmtr3
notes migarea: 1998-present CPS: mig_mtr3