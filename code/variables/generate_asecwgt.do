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

    * population controls used in Census's published historical income tables:
    * Unicon alternate weights for 1980 (1980 Census-based) and 1993 (1990
    * Census-based); revised weights for 2011 (2010 Census-based), 2021 (2020
    * Census-based) and 2025 (Vintage 2025); 2010 and 2020 keep the originals
    if tm(1980m1) <= $date & $date <= tm(1980m12) {
        replace asecwgt = wgtalt/100
    }
    if tm(1993m1) <= $date & $date <= tm(1993m12) {
        replace asecwgt = wgtalt/100
    }
    if tm(2011m1) <= $date & $date <= tm(2011m12) {
        replace asecwgt = marsupwt_rev
    }
    if tm(2021m1) <= $date & $date <= tm(2021m12) {
        replace asecwgt = marsupwt_rev/100
    }
    if tm(2025m1) <= $date & $date <= tm(2025m12) {
        replace asecwgt = marsupwt_rev/100
    }

}

replace asecwgt = . if asecwgt <= 0

label var asecwgt "March/ASEC weight"
notes asecwgt: 1963-1979: wgt
notes asecwgt: 1998-present: marsupwt
notes asecwgt: Population controls match Census's published historical income tables
notes asecwgt: 1980, 1993: wgtalt (1980 and 1990 Census-based alternate weights)
notes asecwgt: 2011: 2010 Census-based revised weights (from IPUMS ASECWT)
notes asecwgt: 2021: 2020 Census-based revised weights; 2025: Vintage 2025 revised weights
notes asecwgt: 1962 and 1966 adjusted using IPUMS methodology