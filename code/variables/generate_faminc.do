********************************************************************************
* Family income: continuous
********************************************************************************
gen byte faminc = .

if $marchcps == 1 {

    if tm(1968m1) <= $date & $date <= tm(1997m12) {
        replace faminc = _faminc
    }

    if tm(1998m1) <= $date {
        replace faminc = ftotval
    }
}

lab val faminc faminc
lab var faminc "Family income: continuous"
notes faminc: faminc_c treats primary and related subfamilies as one household in accordance with the official poverty rate measure
notes faminc: 1968-1997: Unicon faminc
notes faminc: 1998-present: CPS ftotval
