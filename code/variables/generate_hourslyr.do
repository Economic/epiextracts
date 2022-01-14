*******************************************************************************
* Hours worked per week last year
*******************************************************************************

capture rename hrslyr oldhrslyr
gen byte hrslyr = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace hrslyr = oldhrslyr
    }
    if tm(1998m1) <= $date {
        replace hrslyr = hrswk
    }
}

replace hrslyr = . if hrslyr == 0
label var hrslyr "Hours worked last year"
label value hrslyr hrslyr
notes hrslyr: 1968-1997: Unicon hrslyr
notes hrslyr: 1998-present: CPS hrswk
