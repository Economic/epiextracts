*******************************************************************************
* Hours worked per week last year
*******************************************************************************

gen byte hrs_lyr = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace hrs_lyr = hrslyr
    }
    if tm(1998m1) <= $date {
        replace hrs_lyr = hrswk
    }
}

replace hrs_lyr = . if hrs_lyr == 0
label var hrs_lyr "Hours worked last year"
label value hrs_lyr hrs_lyr
notes hrs_lyr: 1968-1997 Unicon: hrslyr
notes hrs_lyr: 1998-present CPS: hrswk