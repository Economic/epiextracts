********************************************************************************
* Census poverty rate indicator
********************************************************************************

gen byte povrate = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1975m12) {
        replace povrate = 0 if pov_lev == 2
        replace povrate = 1 if pov_lev == 1
        replace povrate = . if pov_lev == 0
    }
    if tm(1976m1) <= $date & $date <= tm(1988m12) {
        replace povrate = 0 if 2 <= r_famlis      
        replace povrate = 1 if r_famlis == 1
        replace povrate = . if r_famlis == 0
    }
    if tm(1989m1) <= $date {
        replace povrate = 1 if famlis == 1
        replace povrate = 0 if 2 <= famlis
        replace povrate = . if famlis == -1
    }
}

lab var povrate "Poverty indicator"
lab def povrate 0 "Above poverty level" 1 "Below poverty level" 
label value povrate povrate
notes povrate: Coding changes in 1975
notes povrate: Universe definition from 1968-1979: all persons except for unrelated individuals under age 14
notes povrate: Universe definition from 1968-1979: all persons except for unrelated individuals under age 15
notes povrate: 1968-1997: povlev
notes povrate: 1998-present: famlis