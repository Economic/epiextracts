********************************************************************************
* Market value of school lunch subsidy
********************************************************************************
gen byte schlunch = .

if $marchcps == 1 {
    if tm(1980m1) <= $date & $date <= tm(1987m12) {
        replace schlunch = fmvsl
    }
    * exclude 1988 from variable
    *note: variable only collected in 1988 bridge file
    if tm(1989m1) <= $date & $date <= tm(1997m12) {
       replace schlunch = fmvsl 
    }
    if tm(1998m1) <= $date {
        replace schlunch = f_mv_sl
    }
}

lab var schlunch "School lunch subsidy"
label value schlunch schlunch
notes schlunch: 2010-2018 SPM: fmvsl
notes schlunch: 2019-present: f_mv_sl
