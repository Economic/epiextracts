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
    if tm(1998m1) <= $date & $date <= tm(2013m12) {
        replace asecwgt = marsupwt
    }
    if tm(2014m1) <= $date & $date <= tm(2014m12) {
		replace asecwgt = marsupwt * (3/8) if redesign == 1
		replace asecwgt = marsupwt * (5/8) if redesign == 0
	}
    if tm(2015m1) <= $date & $date <= tm(2018m12) {
        replace asecwgt = marsupwt
    }
    if tm(2019m1) <= $date {
        replace asecwgt = marsupwt/100
    }

    * weights re-estimated with updated population controls, as in IPUMS ASECWT:
    * 2010 Census-based for 2010-2011, 2020 Census-based for 2020-2021
    if tm(2010m1) <= $date & $date <= tm(2011m12) {
        replace asecwgt = marsupwt_rev
    }
    if tm(2020m1) <= $date & $date <= tm(2021m12) {
        replace asecwgt = marsupwt_rev/100
    }

}

replace asecwgt = . if asecwgt <= 0

label var asecwgt "March/ASEC weight"
notes asecwgt: 1963-1979: wgt
notes asecwgt: 1998-present: marsupwt
notes asecwgt: 2010-2011: 2010 Census-based revised weights (IPUMS ASECWT)
notes asecwgt: 2020-2021: 2020 Census-based revised weights (Census replicate weight files)
notes asecwgt: 1962 and 1966 adjusted using IPUMS methodology