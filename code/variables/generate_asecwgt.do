********************************************************************************
* March/ASEC weight
********************************************************************************

gen byte asecwgt = .

if $marchcps == 1 {
    if tm(1962m1) <= $date & $date <= tm(1962m12) {
        replace asecwgt = wgt/100
    }
    if tm(1963m1) <= $date & $date <= tm(1963m12) {
        replace asecwgt = (wgt/100) * 1.3675
    }
    if tm(1964m1) <= $date & $date <= tm(1965m12) {
        replace asecwgt = wgt/100
    }
    if tm(1966m1) <= $date & $date <= tm(1966m12) {
        replace asecwgt = (wgt/100) * 0.5043
    }
    if tm(1967m1) <= $date & $date <= tm(1997m12) {
        replace asecwgt = wgt/100
    }
    if tm(1998m1) <= $date & $date <= tm(2018m12) {
        replace asecwgt = marsupwt
    }
    if tm(2019m1) <= $date {
        replace asecwgt = marsupwt/100
    }
}

replace asecwgt = . if asecwgt < 0

label var asecwgt "March/ASEC weight"
notes asecwgt: 1963-1979: wgt
notes asecwgt: 1998-present: marsupwt 
notes asecwgt: 1962 and 1966 adjusted using IPUMS methodology