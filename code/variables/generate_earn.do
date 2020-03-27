********************************************************************************
* Total personal earnings
********************************************************************************

gen earn = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace earn = incern
    }
    if tm(1998m1) <= $date {
        replace earn = pearnval
    }
}

label var earn "Total personal earnings"
label val earn earn
notes earn: 1976-1997 Unicon: incern
notes earn: 1998-present CPS: pearnval
