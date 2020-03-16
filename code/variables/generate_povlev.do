********************************************************************************
* pov_lev: Poverty level of family
********************************************************************************

capture rename povlev oldpovlev
gen byte povlev = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1975m12) {
    replace povlev = 1 if oldpovlev == 1
    replace povlev = 0 if oldpovlev == 2
    }
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace povlev = 1 if oldpovlev == 1
        replace povlev = 0 if 2 <= oldpovlev
    }
    if tm(1998m1) <= $date {
        replace povlev = 1 if famlis == 1
        replace povlev = 0 if 2 <= famlis
    }
}

lab var povlev "Poverty indicator"
lab def povlev 0 "Income above poverty level" 1 "Income below poverty level" 
label value povlev povlev
notes povlev: Coding changes in 1975
notes povlev: 1968-1997 Unicon: povlev
notes povlev: 1998-present CPS: famlis