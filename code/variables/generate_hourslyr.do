*******************************************************************************
* Hours worked per week last year
*******************************************************************************

capture rename hrslyr oldhrslyr
gen byte hourslyr = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace hourslyr = oldhrslyr
    }
    if tm(1998m1) <= $date {
        replace hourslyr = hrswk
    }
}

replace hourslyr = . if hourslyr == 0
label var hourslyr "Hours worked last year"
label value hourslyr hourslyr
notes hourslyr: 1968-1997 Unicon: hrslyr
notes hourslyr: 1998-present CPS: hrswk