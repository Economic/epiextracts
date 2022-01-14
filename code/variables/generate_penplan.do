********************************************************************************
* Pension plan at work
********************************************************************************
capture rename penplan old_penplan
gen byte penplan = .

if $marchcps == 1 {
    if tm(1980m1) <= $date & $date <= tm(1988m12) {
        replace penplan = 0 if old_penplan == 2
        replace penplan = 1 if old_penplan == 1 & pensincl == 2
        replace penplan = 2 if old_penplan == 1 & pensincl == 1
    }
    if tm(1989m1) <= $date & $date <= tm(1997m12) {
        replace penplan = 0 if old_penplan == 2
        replace penplan = 1 if old_penplan == 1 & pensincl == 2
        replace penplan = 2 if old_penplan == 1 & pensincl == 1
    }
    if tm(1998m1) <= $date {
        replace penplan = 0 if old_penplan == 2
        replace penplan = 1 if old_penplan == 1 & penincl == 2
        replace penplan = 2 if old_penplan == 1 & penincl == 1
    }
}

lab var penplan "Pension plan at work"
lab def penplan 0 "No pension at work" 1 "Pension at work, not included" 2 "Pension at work, included", replace
lab val penplan penplan
notes penplan: 1980-1997 Unicon: penplan & pensincl
notes penplan: 1989-present CPS: penplan & penincl

