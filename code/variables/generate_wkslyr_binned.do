********************************************************************************
* Weeks worked last year: binned
********************************************************************************

capture rename wkslyr oldwkslyr
gen byte wkslyr_binned = .

if $marchcps == 1 {
    if tm(1963m1) <= $date & $date <= tm(1975m12) {
        replace wkslyr_binned = oldwkslyr - 1 if oldwkslyr <= 7
        replace wkslyr_binned = 7 if oldwkslyr == 9
    }
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace wkslyr_binned = 0 if oldwkslyr == 0
        replace wkslyr_binned = 1 if 1 <= oldwkslyr & oldwkslyr <= 13
        replace wkslyr_binned = 2 if 14 <= oldwkslyr & oldwkslyr <= 26
        replace wkslyr_binned = 3 if 27 <= oldwkslyr & oldwkslyr <= 39
        replace wkslyr_binned = 4 if 40 <= oldwkslyr & oldwkslyr <= 47
        replace wkslyr_binned = 5 if 48 <= oldwkslyr & oldwkslyr <= 49
        replace wkslyr_binned = 6 if 50 <= oldwkslyr & oldwkslyr <= 52
    }
    if tm(1998m1) <= $date {
        replace wkslyr_binned = 0 if wkswork == 0
        replace wkslyr_binned = 1 if 1 <= wkswork & wkswork <= 13
        replace wkslyr_binned = 2 if 14 <= wkswork & wkswork <= 26
        replace wkslyr_binned = 3 if 27 <= wkswork & wkswork <= 39
        replace wkslyr_binned = 4 if 40 <= wkswork & wkswork <= 47
        replace wkslyr_binned = 5 if 48 <= wkswork & wkswork <= 49
        replace wkslyr_binned = 6 if 50 <= wkswork & wkswork <= 52        
    }
}

replace wkslyr_binned = . if wkslyr_binned <= 0
label var wkslyr_binned "Weeks worked last year: binned"
#delimit ;
label def wkslyr_binned
1 "1-13 weeks"
2 "14-26 weeks"
3 "27-39 weeks"
4 "40-47 weeks"
5 "48-49 weeks"
6 "50-52 weeks"
7 "Armed forces"
;
#delimit cr
label value wkslyr_binned wkslyr_binned
notes wkslyr_binned: 1963-1997 Unicon: wkslyr
notes wkslyr_binned: 1998-present CPS: wkswork
notes wkslyr_binned: Binned values exist for 1963-1975 in Unicon
notes wkslyr_binned: Armed forces data only available for 1963-1975 data
