********************************************************************************
* pov_cut: Poverty threshold
********************************************************************************

capture rename povcut oldpovcut
gen byte povcut = .

if $marchcps = 1 {
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        *gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 14 <= age
        replace povcut = 0 if faminc > oldpovcut
        replace povcut = 1 if povcut <= faminc 
    }
    if tm(1998m1) <= $date {
        *gen byte universe = 1 if 1 <= famtype & famtype <= 3 & 15 <= age
        replace povcut = 0 if ftotval > fpovcut
        replace povcut = 1 if fpovcut <= ftotval
    }
}

lab var povcut "Poverty threshold"
label def povcut 0 "Family income above poverty threshold" 1 "Family income below poverty threshold"
label value povcut povcut