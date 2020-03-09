********************************************************************************
* pov_cut: Poverty threshold
********************************************************************************

gen byte pov_cut = .

if $marchcps = 1 {
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        replace pov_cut = 0 if faminc > povcut
        replace pov_cut = 1 if povcut <= faminc 
    }
    if tm(1998m1) <= $date {
        replace pov_cut = 0 if ftotval > fpovcut
        replace pov_cut = 1 if fpovcut <= ftotval
    }
}

lab var pov_cut "Poverty threshold"
label def pov_cut 0 "Family income above poverty threshold" 1 "Family income below poverty threshold"
label value pov_cut pov_cut