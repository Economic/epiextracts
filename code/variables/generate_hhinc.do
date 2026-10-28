*******************************************************************************
* Household income: continuous
*******************************************************************************
capture rename hhinc orig_hhinc
gen byte hhinc = .

if $marchcps == 1 {
    if tm(1968m1) <= $date & $date <= tm(1997m12) {
        replace hhinc = _hhinc
    }
    if tm(1998m1) <= $date {
        replace hhinc = htotval
    }
}

label var hhinc "Household income: continuous"
notes hhinc: 1968-1997 Unicon: _hhinc
notes hhinc: 1999 CPS: hoival
notes hhinc: 1998, 2000-present CPS: htotval