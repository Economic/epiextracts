********************************************************************************
* March/ASEC weight
********************************************************************************

gen byte asecwgt = .

if $marchcps == 1 {
    if tm(1963m1) <= $date & $date <= tm(1979m12) {
        replace asecwgt = wgt
    }
    if tm(1980m1) <= $date & $date <= tm(1997m12) {
        replace asecwgt = wgt
        * use retroactively calculated weights to account for lag in Census data  
        if tm(1980m1) <= $date & $date <= tm(1980m12) {
            replace asecwgt = wgtalt
        }
        if tm(1990m1) <= $date & $date <= tm(1990m12) {
            replace asecwgt = wgtalt
        }
    }
    if tm(1998m1) <= $date {
        replace asecwgt = marsupwt
    }
}

label var asecwgt "March/ASEC weight"
notes asecwgt: Sum to civilian, non-institutional population age > 16
notes asecwgt: 1963-1997 Unicon: wgt
notes asecwgt: 1980-1997 Unicon: wgtalt used in available years (1980 & 1990)
notes asecwgt: 1998-present CPS: marsupwt 