********************************************************************************
* Family income: continuous
********************************************************************************
gen byte faminc_c = .

if $marchcps == 1 {
    
    if tm(1968m1) <= $date & $date <= tm(1997m12) {
        replace faminc_c = oldfaminc
    }

    if tm(1998m1) <= $date {
        replace faminc_c = ftotval
    }
}

lab val faminc_c faminc_c
lab var faminc_c "Family income: continuous"
notes faminc_c: faminc_c treats primary and related subfamilies as one household in accordance with the official poverty rate measure
notes faminc_c: 1968-1997: Unicon faminc
notes faminc_c: 1998-present: CPS ftotval