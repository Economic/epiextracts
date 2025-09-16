********************************************************************************
* Official poverty threshold
********************************************************************************
gen byte offpov = .

if $marchcps == 1 {
    
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        replace offpov = 0 if offfaminc > povcut & offpovuniverse == 1
        replace offpov = 1 if offfaminc <= povcut & offpovuniverse == 1
    }
    
    if tm(1998m1) <= $date {
        replace offpov = 0 if offfaminc >= fpovcut & offpovuniverse == 1
        replace offpov = 1 if offfaminc < fpovcut & offpovuniverse == 1
    }
}

lab var offpov "Offical poverty threshold"
label def offpov 0 "Above poverty threshold" 1 "Below poverty threshold"
label value offpov offpov
notes offpov: Universe definition from 1980-present: all persons except for unrelated individuals under age 15
notes offpov: 1968-1997: faminc & povcut
notes offpov: 1998-present: ftotval & fpovcut
