********************************************************************************
* Kind of family
********************************************************************************
gen byte famkind = .

if $marchcps == 1 {
    if tm(1988m1) <= $date & $date <= tm(2018m12) {
        replace famkind = 1 if fkind == 1
        replace famkind = 3 if fkind > 1
    }
    if tm(2019m1) <= $date {
        replace famkind = fkindex if fkindex < 3
        replace famkind = 3 if fkindex >= 3
    }
}

lab var famkind "Kind of family"
#delimit ;
lab def famkind
1 "Opposite-sex married couple family"
2 "Same-sex married couple family"
3 "Single-parent family"
;
#delimit cr;
label value famkind famkind
notes famkind: Universe defined for all families
notes famkind: 1998-2018: fkind
notes famkind: 2019-present: fkindex