********************************************************************************
* Poverty level of family
********************************************************************************

gen byte povlev = .

if $marchcps == 1 { 
    if tm(1976m1) <= $date & $date <= tm(1988m12) {
        replace povlev = r_famlis if r_famlis != 0    
        replace povlev = . if r_famlis == 0
    }
    if tm(1989m1) <= $date {
        replace povlev = famlis if famlis != -1
        replace povlev = . if famlis == -1
    }
}

lab var povlev "Poverty level"
#delimit ;
lab def povlev
1 "Below poverty level"
2 "100–124% of poverty level"
3 "125–149% of poverty level"
4 "150% and above poverty level"
;
#delimit cr;
label value povlev povlev
notes povlev: 1968-1997: r_famlis
notes povlev: 1998-present: famlis