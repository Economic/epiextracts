********************************************************************************
* Intervalled weeks worked last year
********************************************************************************
gen byte i_weeksly = .

if $marchcps == 1 {
    if tm(1963m1) <= $date & $date <= tm(1975m12) {
        replace i_weeksly = wkslyr - 1 if wkslyr <= 7
        replace i_weeksly = 7 if wkslyr == 9
    }
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace i_weeksly = 0 if wkslyr == 0
        replace i_weeksly = 1 if 1 <=  wkslyr & wkslyr <= 13
        replace i_weeksly = 2 if 14 <= wkslyr & wkslyr <= 26
        replace i_weeksly = 3 if 27 <= wkslyr & wkslyr <= 39
        replace i_weeksly = 4 if 40 <= wkslyr & wkslyr <= 47
        replace i_weeksly = 5 if 48 <= wkslyr & wkslyr <= 49
        replace i_weeksly = 6 if 50 <= wkslyr & wkslyr <= 52
    }
    if tm(1998m1) <= $date {
        replace i_weeksly = 0 if wkswork == 0
        replace i_weeksly = 1 if 1 <=  wkswork & wkswork <= 13
        replace i_weeksly = 2 if 14 <= wkswork & wkswork <= 26
        replace i_weeksly = 3 if 27 <= wkswork & wkswork <= 39
        replace i_weeksly = 4 if 40 <= wkswork & wkswork <= 47
        replace i_weeksly = 5 if 48 <= wkswork & wkswork <= 49
        replace i_weeksly = 6 if 50 <= wkswork & wkswork <= 52        
    }
}

replace i_weeksly = . if i_weeksly <= 0

label var i_weeksly "Weeks worked last year: intervalled"
#delimit ;
label def i_weeksly
1 "1-13 weeks"
2 "14-26 weeks"
3 "27-39 weeks"
4 "40-47 weeks"
5 "48-49 weeks"
6 "50-52 weeks"
7 "Armed forces"
;
#delimit cr
label value i_weeksly i_weeksly
notes i_weeksly: 1963-1997 Unicon: wkslyr
notes i_weeksly: 1998-present CPS: wkswork
notes i_weeksly: Binned values exist for 1963-1975 in Unicon
notes i_weeksly: Armed forces data only available for 1963-1975 data