*******************************************************************************
* Household income: continuous
*******************************************************************************

gen byte hhinc_c = .

if $marchcps == 1 {
    if tm(1968m1) <= $date & $date <= tm(1997m12) {
        replace hhinc_c = hhinc
    }
    if tm(1998m1) <= $date {
        replace hhinc_c = htotval
    }
}

label var hhinc_c "Household income: continuous"
label value hhinc_c hhinc_c 
notes hhinc_c: 1968-1997 Unicon: hhinc
notes hhinc_c: 1998-present CPS: htotval