********************************************************************************
* Official poverty threshold cutoff value
********************************************************************************
gen byte offpovcut = .

if $marchcps == 1 {
    
    if tm(1968m1) <= $date & $date <= tm(1997m12) {
        * defined in offfaminc:
            * related: related subfamily indicator
            * rsubfam: presence of related subfamily by household

        * income of primary householder with related subfamily
        bysort hrhhid hserial: egen povcut_rsubfam = max(cond(famtype == 1 & rsubfam == 1, povcut, .))

        replace offpovcut = povcut_rsubfam if offpovuniverse == 1 & rsubfam == 1 & inlist(famtype, 1, 3)
        replace offpovcut = povcut if offpovuniverse == 1 & offpovcut == .
    }

    if tm(1998m1) <= $date {
        * defined in offfaminc:
            * related: related subfamily indicator
            * rsubfam: presence of related subfamily by household

        * income of primary householder with related subfamily
        bysort hrhhid hserial: egen povcut_rsubfam = max(cond(famtype == 1 & rsubfam == 1, fpovcut, .))

        replace offpovcut = povcut_rsubfam if offpovuniverse == 1 & rsubfam == 1 & inlist(famtype, 1, 3)
        replace offpovcut = fpovcut if offpovuniverse == 1 & offpovcut == .

    }
}

lab var offpovcut "Offical poverty threshold value "
label value offpovcut offpovcut
notes offpovcut: 1968-1997 Unicon: povcut
notes offpovcut: 1998-present CPS: fpovcut
