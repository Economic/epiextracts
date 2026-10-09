********************************************************************************
* March/ASEC weight, Census published-series population controls
********************************************************************************

* start from the main weight; override years where Census's published
* historical income tables use different population controls
gen asecwgt_census = asecwgt

if $marchcps == 1 {
    * 1980 Census-based alternate weight (Census series for 1979 income)
    if tm(1980m1) <= $date & $date <= tm(1980m12) {
        replace asecwgt_census = wgtalt/100
    }
    * 1990 Census-based alternate weight (Census series for 1992 income)
    if tm(1993m1) <= $date & $date <= tm(1993m12) {
        replace asecwgt_census = wgtalt/100
    }
    * Census series keeps the original weights for 2009 and 2019 income
    if tm(2010m1) <= $date & $date <= tm(2010m12) {
        replace asecwgt_census = marsupwt
    }
    if tm(2020m1) <= $date & $date <= tm(2020m12) {
        replace asecwgt_census = marsupwt/100
    }
    * Vintage 2025 population controls (Census series for 2024 income)
    if tm(2025m1) <= $date & $date <= tm(2025m12) {
        replace asecwgt_census = marsupwt_rev/100
    }
}

replace asecwgt_census = . if asecwgt_census <= 0

label var asecwgt_census "March/ASEC weight, Census published-series controls"
notes asecwgt_census: Equals asecwgt except where Census's historical income tables use other population controls
notes asecwgt_census: 1980: wgtalt (1980 Census-based); 1993: wgtalt (1990 Census-based)
notes asecwgt_census: 2010, 2020: original marsupwt; 2025: Vintage 2025 revised weights
