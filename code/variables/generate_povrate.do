********************************************************************************
* Census poverty rate indicator
********************************************************************************
gen byte povrate = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1975m12) {
        replace povrate = povlev
    }
    if tm(1976m1) <= $date {
        replace povrate = 0 if povlev == 0     
        replace povrate = 1 if povlev > 0
    }
}

lab var povrate "Poverty indicator"
lab def povrate 0 "Below poverty level" 1 "Above poverty level"
label value povrate povrate
notes povrate: Coding changes in 1975
notes povrate: Universe definition from 1968-1979: all persons except for unrelated individuals under age 14
notes povrate: Universe definition from 1968-1979: all persons except for unrelated individuals under age 15
notes povrate: 1968-present: povlev
