********************************************************************************
* Official poverty threshold
********************************************************************************
gen byte offpovuniverse = .

if $marchcps == 1 {
    * poverty universe excludes secondary individuals that are children
    *note: 1963–1979, children are age < 14
    if tm(1963m1) <= $date & $date <= tm(1967m12) {
        replace offpovuniverse = !(famdesc > 4 & age < 14)
    }
    if tm(1968m1) <= $date & $date <= tm(1979m12) {
        replace offpovuniverse = !(famdesc > 5 & age < 14)
    }
    *note: 1968–present, children are age < 15
    if tm(1980m1) <= $date & $date <= tm(1987m12) {
        replace offpovuniverse = !(famdesc > 5 & age < 15)
    }
    if tm(1988m1) <= $date {
        replace offpovuniverse = !(famtype == 5 & age < 15)
    }
}

lab var offpovuniverse "Official poverty universe"
label def offpovuniverse 0 "Not in poverty universe" 1 "In poverty universe"
label value offpovuniverse offpovuniverse
notes offpovuniverse: Universe definition from 1980-present: all persons except for unrelated individuals under age 15
notes offpovuniverse: 1963-1987: famdesc & age
notes offpovuniverse: 1989-present: famtype & age
