********************************************************************************
* pov_lev: Poverty level of family
********************************************************************************

gen byte pov_lev = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1975m12) {
    replace pov_lev = 1 if povlev == 1
    replace pov_lev = 0 if povlev == 2
    }
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace pov_lev = 1 if povlev == 1
        replace pov_lev = 0 if 2 <= povlev
    }
    if tm(1998m1) <= $date {
        replace pov_lev = 1 if famlis == 1
        replace pov_lev = 0 if 2 <= famlis
    }
}

lab var pov_lev "Poverty indicator"
lab def pov_lev 0 "Income above poverty level" 1 "Income below poverty level" 
label value povlev pov_lev
notes pov_lev: Coding changes in 1975
notes pov_lev: 1968-1997 Unicon: povlev
notes pov_lev: 1998-present CPS: famlis