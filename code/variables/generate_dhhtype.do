********************************************************************************
* Detailed household summary
********************************************************************************
gen byte dhhtype = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1987m12) {
        replace dhhtype = r_hhdrel if r_hhdrel < 3
        replace dhhtype = 3 if r_hhdrel == 3 | r_hhdrel == 4
        replace dhhtype = r_hhdrel - 1 if r_hhdrel > 4
    }
    if tm(1988m1) <= $date {
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
notes dhhtype: 1976-present: hhdrel