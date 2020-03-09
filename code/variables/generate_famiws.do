********************************************************************************
* Family income: wages and salaries, continuous
********************************************************************************

gen byte famiws = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace famiws = fmiwag
    }
    if tm(1998m1) <= $date {
        replace famiws = fwsval
    }
}

label var famiws "Family income: wages & salaries (continuous)"
label value famiws famiws
notes famiws: 1976-1997 Unicon: fmiwag
notes famiws: 1998-present CPS: fwsval