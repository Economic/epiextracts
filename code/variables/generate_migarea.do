********************************************************************************
* Migration, within area moves
********************************************************************************
gen byte migarea = .

if $marchcps == 1 {
    if tm(1968m1) <= $date & $date <= tm(1971m12) {
        replace migarea = 1 if miggen == 1
        replace migarea = 2 if miggen == 2
        replace migarea = 3 if miggen == 3 
        replace migarea = 7 if miggen == 8
        replace migarea = 8 if 4 <= miggen & miggen <= 7
    }
    if tm(1976m1) <= $date & $date <= tm(1976m12) {
        replace migarea = 1 if miggen == 1
        replace migarea = 2 if miggen == 2
        replace migarea = 3 if inlist(miggen, 3, 4)
        replace migarea = 7 if miggen == 8
        replace migarea = 8 if 5 <= miggen & miggen <= 7
    }
    if tm(1977m1) <= $date & $date <= tm(1987m12) {
        replace migarea = 1 if miggen == 1
        replace migarea = 2 if miggen == 2
        replace migarea = 3 if inlist(miggen, 3, 4, 9)
        replace migarea = 7 if miggen == 7
        replace migarea = 8 if 5 <= miggen & miggen <= 6
    }
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        * migmtr3 missing for 1995; use migsam and mig3rec instead
        if tm(1995m1) <= $date & $date <= tm(1995m12) {
            replace migarea = 1 if migsam == 1
            replace migarea = 2 if mig3rec == 1
            replace migarea = 3 if mig3rec == 2
            replace migarea = 8 if mig3rec == 3
            replace migarea = 7 if mig3rec == 4
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
5 "Different division, same region"
6 "Different region"
7 "Abroad"
8 "Moved between states"
;
#delimit cr;
label value migarea migarea
notes migarea: Not available 1972-1975
notes migarea: 1968-1987 and 1995: interstate moves not broken out by division/region; coded as 8 (Moved between states)
notes migarea: 1968-1987 Unicon: miggen
notes migarea: 1988-1994, 1996-1997 Unicon: migmtr3
notes migarea: 1995 Unicon: migsam, mig3rec
notes migarea: 1998-present CPS: mig_mtr3
