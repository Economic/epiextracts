********************************************************************************
* Weeks worked last year
********************************************************************************

gen byte wks_lyr = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace wks_lyr = wkslyr
    }
    if tm(1998m1) <= $date {
        replace wks_lyr = wkswork
    }
}

replace wks_lyr = . if wks_lyr <= 0
label var wks_lyr "Weeks worked last year"
label value wks_lyr wks_lyr
notes wks_lyr: 1976-1997 Unicon: wkslyr
notes wks_lyr: 1998-present CPS: wkswork