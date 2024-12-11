********************************************************************************
* Poverty level of family
********************************************************************************

gen byte povrate = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1975m12) {
        *gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 14 <= age
        replace povrate = 0 if povlev == 2 & universe == 1
        replace povrate = 1 if povlev == 1 & universe == 1
        replace povrate = . if universe != 1
    }
    if tm(1976m1) <= $date & $date <= tm(1979m12) {
        *gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 14 <= age
        replace povrate = 0 if 2 <= povlev & universe == 1         
        replace povrate = 1 if povlev == 1 & universe == 1
        replace povrate = . if universe != 1
    }
    if tm(1980m1) <= $date & $date <= tm(1997m12) {
        *gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 15 <= age
        replace povrate = 1 if povlev == 1 & universe == 1
        replace povrate = 0 if 2 <= povlev & universe == 1
        replace povrate = . if universe != 1
    }
    if tm(1998m1) <= $date {
        replace povrate = 1 if famlis == 1
        replace povrate = 0 if 2 <= famlis
        replace povrate = . if famlis == -1
    }
}

lab var povrate "Poverty indicator"
lab def povrate 0 "Income above poverty level" 1 "Income below poverty level" 
label value povrate povrate
notes povrate: Coding changes in 1975
notes povrate: Universe definition from 1968-1979: all persons except for unrelated individuals under age 14
notes povrate: Universe definition from 1968-1979: all persons except for unrelated individuals under age 15
notes povrate: 1968-1997: povlev
notes povrate: 1998-present: famlis