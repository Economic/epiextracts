********************************************************************************
* Status of migration
********************************************************************************
gen byte migstatus = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1987m12) {
        replace migstatus = mig_same
        replace migstatus = . if mig_same == 0
    }
    if tm(1988m1) <= $date & $date <= tm(1994m12) {
        replace migstatus = migsame
        replace migstatus = . if migsame == 0
    }
    if tm(1995m1) <= $date & $date <= tm(1995m12) {
        replace migstatus = pemovsan
        replace migstatus = . if pemovsan == 0
    }
    if tm(1996m1) <= $date {
        replace migstatus = migsame
        replace migstatus = . if migsame == 0
    }
}

lab var migstatus "Migration status"
#delimit ;
lab def migstatus
1 "Non-mover"
2 "Mover, domestic"
3 "Mover, abroad"
;
#delimit cr;
label value migstatus migstatus
notes migstatus: 1976-present: migsame