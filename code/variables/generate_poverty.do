********************************************************************************
* Poverty level of family
********************************************************************************

gen byte poverty = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1975m12) {
        *gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 14 <= age
        replace poverty = 0 if povlev == 2 & universe == 1
        replace poverty = 1 if povlev == 1 & universe == 1
        replace poverty = . if universe != 1
    }
    if tm(1976m1) <= $date & $date <= tm(1979m12) {
        *gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 14 <= age
        replace poverty = 0 if 2 <= povlev & universe == 1         
        replace poverty = 1 if povlev == 1 & universe == 1
        replace poverty = . if universe != 1
    }
    if tm(1980m1) <= $date & $date <= tm(1997m12) {
        replace poverty = 1 if povlev == 1 & universe == 1
        replace poverty = 0 if 2 <= povlev & universe == 1
        replace poverty = . if universe != 1
    }
    if tm(1998m1) <= $date {
        replace poverty = famlis
        replace poverty = . if famlis == -1
        
    }
}

lab var poverty "Poverty level indicator"
#delimit ;
lab def poverty
1 "Below poverty level"
2 "100–124% of poverty level"
3 "125–149% of poverty level"
4 "150% and above poverty level"
;
#delimit cr;
label value poverty poverty
notes poverty: Coding changes in 1975
notes poverty: Universe definition from 1968-1979: all persons except for unrelated individuals under age 14
notes poverty: Universe definition from 1968-1979: all persons except for unrelated individuals under age 15
notes poverty: 1968-1997: povlev
notes poverty: 1998-present: famlis