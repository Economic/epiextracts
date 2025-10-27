********************************************************************************
* Official poverty threshold
********************************************************************************
gen byte offpovuniverse = .

if $marchcps == 1 {
    * poverty universe excludes secondary individuals under 15
    if tm(1962m1) <= $date & $date <= tm(1987m12) {
        replace offpovuniverse = !(famdesc > 5 & age < 15)
    }
    if tm(1988m1) <= $date {
        replace offpovuniverse = !(famtype == 5 & age < 15)
        *replace offpovuniverse = 1 if offpovuniverse != 0

    }
}

lab var offpovuniverse "Official poverty universe"
label def offpovuniverse 0 "Not in poverty universe" 1 "In poverty universe"
label value offpovuniverse offpovuniverse
notes offpovuniverse: Universe definition from 1980-present: all persons except for unrelated individuals under age 15
notes offpovuniverse: 1968-1997: faminc & povcut
notes offpovuniverse: 1998-present: ftotval & fpovcut
