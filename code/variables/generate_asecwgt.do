********************************************************************************
* March/ASEC weight
********************************************************************************

gen byte asecwgt = .

if $marchcps == 1 {
    if tm(1963m1) <= $date & $date <= tm(1979m12) {
        replace asecwgt = wgt
    }
    if tm(1980m1) <= $date & $date <= tm(1997m12) {
        * use retroactively calculated weights to account for lag in Census data  
        if tm(1980m1) <= $date & $date <= tm(1980m12) {
            replace asecwgt = wgtalt
        }
        else if tm(1990m1) <= $date & $date <= tm(1990m12) {
            replace asecwgt = wgtalt
        }
        else {
            replace asecwgt = wgt
        }
    }
    if tm(1998m1) <= $date {
        replace asecwgt = marsupwt
    }
}

replace asecwgt = . if asecwgt < 0

label var asecwgt "March/ASEC weight"
notes asecwgt: 1963-1979: wgt
notes asecwgt: 1980-1997: wgtalt used in available years (1980 & 1990)
notes asecwgt: 1998-present: marsupwt 