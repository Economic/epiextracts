*******************************************************************************
* Hours worked per week last year
*******************************************************************************
gen byte hoursly = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace hoursly = hrslyr
    }
    if tm(1998m1) <= $date {
        replace hoursly = hrswk
    }
}

replace hoursly = . if hoursly == 0

label var hoursly "Hours worked last year"
label value hoursly hoursly
notes hoursly: 1968-1997 Unicon: hrslyr
notes hoursly: 1998-present CPS: hrswk