********************************************************************************
* Poverty level of family
********************************************************************************
capture rename povlev orig_povlev
gen byte povlev = .

if $marchcps == 1 { 
    if tm(1968m1) <= $date & $date <= tm(1975m12) {
        replace povlev = 0 if orig_povlev == 1
        replace povlev = 1 if orig_povlev == 2
    }
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace povlev = orig_povlev if orig_povlev > 1
        replace povlev = 0 if orig_povlev == 1   
    }
    if tm(1998m1) <= $date {
        replace povlev = famlis if famlis > 1
        replace povlev = 0 if famlis == 1
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
