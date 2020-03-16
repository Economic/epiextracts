********************************************************************************
* pov_cut: Poverty threshold
********************************************************************************

capture rename povcut oldpovcut
gen byte povcut = .

if $marchcps = 1 {
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        replace povcut = 0 if faminc > oldpovcut
        replace povcut = 1 if povcut <= faminc 
    }
    if tm(1998m1) <= $date {
        replace povcut = 0 if ftotval > fpovcut
        replace povcut = 1 if fpovcut <= ftotval
    }
}

lab var povcut "Poverty threshold"
label def povcut 0 "Family income above poverty threshold" 1 "Family income below poverty threshold"
label value povcut povcut