********************************************************************************
* Household weight, Census published-series population controls
********************************************************************************

* start from the main household weight; override years where Census's
* published historical income tables use different population controls
gen hhwgt_census = hhwgt

if $marchcps == 1 {
    * 1980 Census-based: alternate weight of the household head
    if tm(1980m1) <= $date & $date <= tm(1980m12) {
        bysort hserial: egen hhwgt_census_head = max(cond(_relhd == 1, asecwgt_census, .))
        replace hhwgt_census = hhwgt_census_head
        drop hhwgt_census_head
    }
    * 1990 Census-based alternate household weight
    if tm(1993m1) <= $date & $date <= tm(1993m12) {
        replace hhwgt_census = hhwgtalt/100
    }
    * Census series keeps the original weights for 2009 and 2019 income
    if tm(2010m1) <= $date & $date <= tm(2010m12) {
        replace hhwgt_census = hsup_wgt
    }
    if tm(2020m1) <= $date & $date <= tm(2020m12) {
        replace hhwgt_census = hsup_wgt/100
    }
    * Vintage 2025: reference person's revised supplement weight
    if tm(2025m1) <= $date & $date <= tm(2025m12) {
        bysort hserial: egen hhwgt_census_refper = max(cond(inlist(a_exprrp, 1, 2), asecwgt_census, .))
        replace hhwgt_census = hhwgt_census_refper
        drop hhwgt_census_refper
    }

    * same household universe as hhwgt (excludes group quarters)
    replace hhwgt_census = . if missing(hhwgt)
}

label var hhwgt_census "Household weight, Census published-series controls"
notes hhwgt_census: Equals hhwgt except where Census's historical income tables use other population controls
notes hhwgt_census: 1980: head's wgtalt (1980 Census-based); 1993: hhwgtalt (1990 Census-based)
notes hhwgt_census: 2010, 2020: original hsup_wgt; 2025: reference person's Vintage 2025 revised weight
notes hhwgt_census: Missing for group quarters units, as hhwgt
