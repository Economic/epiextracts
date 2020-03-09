*******************************************************************************
* Total family earnings
*******************************************************************************

gen byte fam_ern = .

if $marchcps == 1 {
    if tm(1968m1) <= $date & $date <= tm(1997m12) {
        replace fam_ern = famern 
    }
    if tm(1998m1) <= $date {
        replace fam_ern = fearnval
    }
}

label var fam_ern "Total family earnings"
label val fam_ern fam_ern
notes fam_ern: 1968-1997 Unicon: famern
notes fam_ern: 1998-present CPS: fearnval