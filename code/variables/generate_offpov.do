********************************************************************************
* Official poverty threshold
********************************************************************************
gen byte offpov = .

if $marchcps == 1 {
    * poverty universe excludes secondary individuals under 15
    gen byte universe = 0 if famtype == 5 & age < 15
    
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        replace offpov = 0 if faminc > povcut & universe != 0
        replace offpov = 1 if faminc <= povcut & universe != 0
    }
    
    if tm(1998m1) <= $date {
        replace offpov = 0 if ftotval > fpovcut & universe != 0
        replace offpov = 1 if ftotval <= fpovcut & universe != 0
    }
}

lab var offpov "Offical poverty threshold"
label def offpov 0 "Above poverty threshold" 1 "Below poverty threshold"
label value offpov offpov
notes offpov: Universe definition from 1980-present: all persons except for unrelated individuals under age 15
notes offpov: 1968-1997: faminc & povcut
notes offpov: 1998-present: ftotval & fpovcut
