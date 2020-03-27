********************************************************************************
* pov_lev: Poverty level of family
********************************************************************************

gen byte poverty = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1975m12) {
        gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 14 <= age
        replace poverty = 0 if povlev == 2 & universe == 1
        replace poverty = 1 if povlev == 1 & universe == 1
        replace poverty = . if universe != 1
    }
    if tm(1976m1) <= $date & $date <= tm(1979m12) {
        gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 14 <= age
        replace poverty = 0 if 2 <= povlev & universe == 1         
        replace poverty = 1 if povlev == 1 & universe == 1
        replace poverty = . if universe != 1
    }
    if tm(1980m1) <= $date & $date <= tm(1997m12) {
        gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 15 <= age
        replace poverty = 1 if povlev == 1 & universe == 1
        replace poverty = 0 if 2 <= povlev & universe == 1
        replace poverty = . if universe != 1
    }
    if tm(1998m1) <= $date {
        gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 15 <= age
        replace poverty = 1 if famlis == 1 & universe == 1
        replace poverty = 0 if 2 <= famlis & universe == 1
        replace poverty = . if universe != 1
    }
}

lab var poverty "Poverty indicator"
lab def poverty 0 "Income above poverty level" 1 "Income below poverty level" 
label value poverty poverty
notes poverty: Coding changes in 1975
notes poverty: Universe definition from 1968-1979: all persons except for unrelated individuals under age 14
notes poverty: Universe definition from 1968-1979: all persons except for unrelated individuals under age 15
notes poverty: 1968-1997: povlev
notes poverty: 1998-present: famlis