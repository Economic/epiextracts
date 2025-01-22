********************************************************************************
* Presence of disability/health problem that limited employment
********************************************************************************
gen byte disability = .

if $marchcps == 1 {
    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        replace disability = 0 if hrcpds == 2
        replace disability = 1 if hrcpds == 1
    }
    if tm(1998m1) <= $date {
        replace disability = 0 if hdis_yn == 2
        replace disability = 1 if hdis_yn == 1
    }
}

lab var disability "Disability/health problem"
lab def disability 0 "Not disabled" 1 "Disabled"
label value disability disability
notes disability: 1988-1997 Unicon: hrcpds
notes disability: 1998-present CPS: hdis_yn