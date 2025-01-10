********************************************************************************
* Migration metropolitan status, before and after move
********************************************************************************
gen byte migmetro = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1976m12) {
        replace migmetro = 1 if 2 <= mtr1rec & mtr1rec <= 9
        replace migmetro = 2 if 10 <= mtr1rec & mtr1rec <= 11
        replace migmetro = 3 if 12 <= mtr1rec & mtr1rec <= 13
        replace migmetro = 4 if mtr1rec == 14
        replace migmetro = 5 if 15 <= mtr1rec & mtr1rec <= 16
        replace migmetro = 6 if mtr1rec == 17
        replace migmetro = . if mtr1rec == 8


    }
    if tm(1977m1) <= $date & $date <= tm(1987m12) {
        replace migmetro = mtr1rec-1
        replace migmetro = . if mtr1rec == 1 | mtr1rec >= 8
    }
    if tm(1998m1) <= $date {
        replace migmetro = mig_mtr1-1
        replace migmetro = . if mig_mtr1 == 1 | mig_mtr1 >= 8
    }
}

lab var migmetro "Migration status"
#delimit ;
lab def migmetro
1 "Metro to metro"
2 "Metro to non-metro"
3 "Non-metro to metro"
4 "Non-mtero to non-metro"
5 "Abroad to metro"
6 "Abroad to non-metro"
;
#delimit cr;
label value migmetro migmetro
notes migmetro: Universe defined for all persons that moved in the previous year
notes migmetro: 1976-present: mig_reg