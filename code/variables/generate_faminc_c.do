********************************************************************************
* Family income: continuous
********************************************************************************

gen byte faminc_c = .

if $marchcps == 1 {
    if tm(1968m1) <= $date & $date <= tm(1995m12) {
        replace faminc_c = faminc
    }
    if tm(1976m1) <= $date & $date <= tm(1987m12) {
        replace faminc_c = faminc
    }
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        replace faminc_c = faminc
    }
    if tm(1998m1) <= $date {
        replace faminc_c = ftotval
    }
}

lab val faminc_c faminc_c
lab var faminc_c "Family income category: continuous"
notes faminc_c: 1968-1997: Unicon faminc
notes faminc_c: 1998-present: CPS ftotval