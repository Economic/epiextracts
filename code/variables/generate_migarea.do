********************************************************************************
* Migration, within area moves
********************************************************************************
gen byte migarea = .

if $marchcps == 1 {
    if tm(1995m1) <= $date {
        replace migarea = mig_mtr3-1
        replace migarea = . if mig_mtr3 == 1 | mig_mtr3 >= 8
    }
}

lab var migarea "Migration status"
#delimit ;
lab def migarea
1 "Same county"
2 "Different county, same state"
3 "Different state, same division"
4 "Different divion, same region"
5 "Different region"
6 "Abroad"
;
#delimit cr;
label value migarea migarea
notes migarea: Universe defined for all persons that moved in the previous year
notes migarea: 1995-present: mig_mtr3