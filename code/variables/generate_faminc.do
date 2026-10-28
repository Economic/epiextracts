********************************************************************************
* Family income: continuous
********************************************************************************
gen byte faminc = .

if $marchcps == 1 {

    if tm(1963m1) <= $date & $date <= tm(1997m12) {
        replace faminc = _faminc
    }

    if tm(1998m1) <= $date {
        replace faminc = ftotval
    }
}

lab var faminc "Family income: continuous"
notes faminc: Income of the person's own family; related subfamilies have their own income (see offfaminc for primary and related subfamilies combined)
notes faminc: 1963-1997: Unicon faminc
notes faminc: 1998-present: CPS ftotval
