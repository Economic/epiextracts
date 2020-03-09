********************************************************************************
* Total personal income
********************************************************************************

capture rename income oldincome
gen income = . 

if $marchcps == 1 {
    if tm(1962m1) <= $date & $date <= tm(1997m12) {
        replace income = oldincome
    }
    if tm(1998m1) <= $date {
        replace income = ptotval
    }
}

lab var income "Total personal income"
label val income income
notes income: 1980 onward universe defined for 15+
notes income: 1962-1997 Unicon: income
notes income: 1998-present CPS: ptotval
