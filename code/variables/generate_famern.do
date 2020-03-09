*******************************************************************************
* Total family earnings
*******************************************************************************

capture rename famern oldfamern
gen byte famern = .

if $marchcps == 1 {
    if tm(1968m1) <= $date & $date <= tm(1997m12) {
        replace famern = oldfamern 
    }
    if tm(1998m1) <= $date {
        replace famern = fearnval
    }
}

label var famern "Total family earnings"
label val famern famern
notes famern: 1968-1997 Unicon: famern
notes famern: 1998-present CPS: fearnval