********************************************************************************
* Official poverty threshold cutoff value
********************************************************************************
gen byte offpovcut = .

if $marchcps == 1 {
    if tm(1968m1) <= $date & $date <= tm(1997m12) {
        replace offpovcut = povcut
    }

    if tm(1998m1) <= $date {
        replace offpovcut = fpovcut
    }
}

lab var offpovcut "Offical poverty threshold value "
label value offpovcut offpovcut
notes offpovcut: 1968-1997 Unicon: povcut
notes offpovcut: 1998-present CPS: fpovcut
