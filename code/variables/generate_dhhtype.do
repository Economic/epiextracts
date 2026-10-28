********************************************************************************
* Detailed household summary
********************************************************************************
gen byte dhhtype = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace dhhtype = hhrel2 if hhrel2 < 3
        replace dhhtype = 3 if hhrel2 == 3 | hhrel2 == 4
        replace dhhtype = hhrel2 - 1 if hhrel2 > 4
    }
    if tm(1998m1) <= $date {
        replace dhhtype = hhdrel if hhdrel < 3
        replace dhhtype = 3 if hhdrel == 3 | hhdrel == 4
        replace dhhtype = hhdrel - 1 if hhdrel > 4
    }
}

lab var dhhtype "Detailed household type"
#delimit ;
lab def dhhtype
1 "Householder"
2 "Spouse of householder"
3 "Child of householder, under 18"
4 "Child of household, 18 year and over"
5 "Other relative of householder"
6 "Non-relative of householder"
7 "Secondary individual"
;
#delimit cr;
label value dhhtype dhhtype
notes dhhtype: Universe defined for all persons that moved in the previous year
notes dhhtype: 1976-1997 Unicon March: hhrel2
notes dhhtype: 1998-present CPS March: hhdrel