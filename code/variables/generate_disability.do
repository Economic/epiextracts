********************************************************************************
* Presence of disability/health problem that limited employment
********************************************************************************
gen byte disability = .

if $marchcps == 1 {
    if tm(1988m1) <= $date {
        replace disability = hdis_yn
        replace disability = . if hdis_yn == 0
    }
}

lab var disability "Disability/health problem"
lab def disability 1 "Disabled" 2 "Not disabled"
label value disability disability
notes disability: 1988-present: hdis_yn