********************************************************************************
* Status of migration
********************************************************************************
gen byte migstatus = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1987m12) {
        if tm(1980m1) <= $date & $date <= tm(1980m12) {
            replace migstatus = .
        }
        else if tm(1985m1) <= $date & $date <= tm(1985m12) {
            replace migstatus = .
        }
        else {
            replace migstatus = 1 if migsam == 1
            replace migstatus = 4 if migsam == 0
        }
        
    }
    if tm(1988m1) <= $date & $date <= tm(1994m12) {
        replace migstatus = 1 if migsam == 2
        replace migstatus = 4 if migsam == 1
        replace migstatus = . if migsam == 0
    }
    if tm(1995m1) <= $date & $date <= tm(1997m12) {
        replace migstatus = migsam
        replace migstatus = . if migstatus == 0
    }
    if tm(1998m1) <= $date {
        replace migstatus = migsame
        replace migstatus = . if migstatus == 0
    }
}

lab var migstatus "Migration status"
#delimit ;
lab def migstatus
1 "Nonmover"
2 "Mover, domestic"
3 "Mover, abroad"
4 "Mover"
;
#delimit cr;
label value migstatus migstatus
notes migstatus: 1962-1997 Unicon March: migsam
notes migstatus: 1998-present CPS March: migsame
notes migstatus: Unicon data missing for 1980 and 1985
