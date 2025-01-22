********************************************************************************
* Presence of parents indicator
********************************************************************************
capture rename parent orig_parent
gen byte parent = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace parent = prntrc
        replace parent = . if parent == 0
    }
    if tm(1998m1) <= $date {
        replace parent = orig_parent
        replace parent = . if parent == 0
    }
}

lab var parent "Detailed household type"
#delimit ;
lab def parent
1 "Both parents present"
2 "Mother only"
3 "Father only"
4 "No parent present"
;
#delimit cr;
label value parent parent
notes parent: Universe defined for all family members under 18
notes parent: 1976-1997 Unicon: prntrc
notes parent: 1998-present CPS: parent
