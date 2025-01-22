********************************************************************************
* Weeks worked last year: binned
********************************************************************************
gen byte wksly = .

if $marchcps == 1 {
    if tm(1963m1) <= $date & $date <= tm(1975m12) {
        replace wksly = wkslyr - 1 if wkslyr <= 7
        replace wksly = 7 if wkslyr == 9
    }
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace wksly = 0 if wkslyr == 0
        replace wksly = 1 if 1 <=  wkslyr & wkslyr <= 13
        replace wksly = 2 if 14 <= wkslyr & wkslyr <= 26
        replace wksly = 3 if 27 <= wkslyr & wkslyr <= 39
        replace wksly = 4 if 40 <= wkslyr & wkslyr <= 47
        replace wksly = 5 if 48 <= wkslyr & wkslyr <= 49
        replace wksly = 6 if 50 <= wkslyr & wkslyr <= 52
    }
    if tm(1998m1) <= $date {
        replace wksly = 0 if wkswork == 0
        replace wksly = 1 if 1 <=  wkswork & wkswork <= 13
        replace wksly = 2 if 14 <= wkswork & wkswork <= 26
        replace wksly = 3 if 27 <= wkswork & wkswork <= 39
        replace wksly = 4 if 40 <= wkswork & wkswork <= 47
        replace wksly = 5 if 48 <= wkswork & wkswork <= 49
        replace wksly = 6 if 50 <= wkswork & wkswork <= 52        
    }
}

replace wksly = . if wksly <= 0

label var wksly "Weeks worked last year: binned"
#delimit ;
label def wksly
1 "1-13 weeks"
2 "14-26 weeks"
3 "27-39 weeks"
4 "40-47 weeks"
5 "48-49 weeks"
6 "50-52 weeks"
7 "Armed forces"
;
#delimit cr
label value wksly wksly
notes wksly: 1963-1997 Unicon: wkslyr
notes wksly: 1998-present CPS: wkswork
notes wksly: Binned values exist for 1963-1975 in Unicon
notes wksly: Armed forces data only available for 1963-1975 data