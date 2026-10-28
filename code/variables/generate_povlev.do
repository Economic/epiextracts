********************************************************************************
* Poverty level of family
********************************************************************************
capture rename povlev orig_povlev
gen byte povlev = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1971m12) {
        gen byte old_povlev = .

        replace old_povlev = 0 if orig_povlev == 1
        replace old_povlev = 1 if orig_povlev == 2
        
        bysort hrhhid hserial: egen povlev_rsubfam = max(cond(famtype == 1 & rsubfam == 1, old_povlev, .))

        replace povlev = old_povlev
        replace povlev = povlev_rsubfam if povlev == .
        replace povlev = . if offpovuniverse == 0
    }
    if tm(1972m1) <= $date & $date <= tm(1975m12) {   
        gen byte old_povlev = .

        replace old_povlev = 0 if orig_povlev == 1
        replace old_povlev = 1 if orig_povlev == 2
        
        replace povlev = old_povlev
        replace povlev = offpovcut < offfaminc if related == 1
        replace povlev = . if offpovuniverse == 0
    }
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace povlev = orig_povlev if orig_povlev > 1
        replace povlev = 0 if orig_povlev == 1   
    }
    if tm(1998m1) <= $date & $date <= tm(2019m12) {
        replace povlev = famlis if famlis > 1
        replace povlev = 0 if famlis == 1
    }
        if tm(2020m1) <= $date {
        replace povlev = famlis if famlis > 1
        replace povlev = 0 if famlis == 1
        replace povlev = . if famlis == -1
    }
}

lab var povlev "Poverty level"
#delimit ;
lab def povlev
0 "Below poverty level"
1 "Above poverty level"
2 "100–124% of poverty level"
3 "125–149% of poverty level"
4 "150% and above poverty level"
;
#delimit cr;
label value povlev povlev
notes povlev: 1968-1997 Unicon: povlev
notes povlev: 1998-present CPS: famlis
