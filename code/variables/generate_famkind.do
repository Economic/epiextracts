********************************************************************************
* Family type (family level)
********************************************************************************

gen byte famkind = . 

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1987m12) {
        replace famkind = 1 if famknd == 1
        replace famkind = 2 if famknd == 4
        replace famkind = 3 if famknd == 2
        replace famkind = 4 if famknd == 3
        replace famkind = 5 if famknd == 5
    }
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        replace famkind = famknd
    }
    if tm(1998m1) <= $date {
        replace famkind = ftype
    }
}

#delimit ;
lab def famkind
1 "Primary family"
2 "Primary individual"
3 "Related subfamily"
4 "Unrelated secondary family"
5 "Unrelated secondary individual"
;
#delimit cr;
label val famkind famkind
label var famkind "Family type (family level)"
notes famkind: 1976-1997: March Unicon famknd
notes famkind: 1998-present: March CPS ftype