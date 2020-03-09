********************************************************************************
* Weeks worked last year
********************************************************************************

capture rename wkslyr oldwkslyr
gen byte wkslyr = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace wkslyr = oldwkslyr
    }
    if tm(1998m1) <= $date {
        replace wkslyr = wkswork
    }
}

replace wkslyr = . if wkslyr <= 0
label var wkslyr "Weeks worked last year"
label value wkslyr wkslyr
notes wkslyr: 1976-1997 Unicon: wkslyr
notes wkslyr: 1998-present CPS: wkswork