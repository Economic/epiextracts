********************************************************************************
* Migration metropolitan status, before and after move (last year)
********************************************************************************
gen byte migmetro = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1976m12) {
        replace migmetro = 1 if migmtr1 == 1
        replace migmetro = 2 if 2 <= migmtr1 & migmtr1 <= 9
        replace migmetro = 3 if 10 <= migmtr1 & migmtr1 <= 11
        replace migmetro = 4 if 12 <= migmtr1 & migmtr1 <= 13
        replace migmetro = 5 if migmtr1 == 14
        replace migmetro = 6 if 15 <= migmtr1 & migmtr1 <= 16
        replace migmetro = 7 if migmtr1 == 17


    }
    if tm(1977m1) <= $date & $date <= tm(1987m12) {
        if tm(1980m1) <= $date & $date <= tm(1980m12) {
            replace migmetro = .
        }
        else if tm(1985m1) <= $date & $date <= tm(1985m12) {
            replace migmetro = .
        }
        else {
            replace migmetro = migmtr1
            replace migmetro = . if migmtr1 >= 8
        }
        
    }
    if tm(1998m1) <= $date {
        replace migmetro = mig_mtr1
        replace migmetro = . if mig_mtr1 >= 8
    }
}

lab var migmetro "Migration status"
#delimit ;
lab def migmetro
1 "Nonmover"
2 "Metro to metro"
3 "Metro to non-metro"
4 "Non-metro to metro"
5 "Non-mtero to non-metro"
6 "Abroad to metro"
7 "Abroad to non-metro"
;
#delimit cr;
label value migmetro migmetro
notes migmetro: Universe defined for all persons that moved in the previous year
notes migmetro: 1976-1997 Unicon: migmtr1
notes migmetro: 1998-present CPS: mig_mtr1
notes migmetro: Unicon data missing for 1980 and 1985
