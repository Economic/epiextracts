********************************************************************************
* Weeks worked last year: binned
********************************************************************************

gen byte wks_lyr_binned = .

if $marchcps == 1 {
    if tm(1963m1) <= $date & $date <= tm(1975m12) {
        replace wks_lyr_binned = wkslyr - 1 if wkslyr <= 7
        replace wks_lyr_binned = 7 if wkslyr == 9
    }
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace wks_lyr_binned = 0 if wkslyr == 0
        replace wks_lyr_binned = 1 if 1 <= wkslyr & wkslyr <= 13
        replace wks_lyr_binned = 2 if 14 <= wkslyr & wkslyr <= 26
        replace wks_lyr_binned = 3 if 27 <= wkslyr & wkslyr <= 39
        replace wks_lyr_binned = 4 if 40 <= wkslyr & wkslyr <= 47
        replace wks_lyr_binned = 5 if 48 <= wkslyr & wkslyr <= 49
        replace wks_lyr_binned = 6 if 50 <= wkslyr & wkslyr <= 52
    }
    if tm(1998m1) <= $date {
        replace wks_lyr_binned = 0 if wkswork == 0
        replace wks_lyr_binned = 1 if 1 <= wkswork & wkswork <= 13
        replace wks_lyr_binned = 2 if 14 <= wkswork & wkswork <= 26
        replace wks_lyr_binned = 3 if 27 <= wkswork & wkswork <= 39
        replace wks_lyr_binned = 4 if 40 <= wkswork & wkswork <= 47
        replace wks_lyr_binned = 5 if 48 <= wkswork & wkswork <= 49
        replace wks_lyr_binned = 6 if 50 <= wkswork & wkswork <= 52        
    }
}

replace wks_lyr_binned = . if wks_lyr_binned <= 0
label var wks_lyr_binned "Weeks worked last year: binned"
#delimit ;
label def wks_lyr_binned
1 "1-13 weeks"
2 "14-26 weeks"
3 "27-39 weeks"
4 "40-47 weeks"
5 "48-49 weeks"
6 "50-52 weeks"
7 "Armed forces"
;
#delimit cr
label value wks_lyr_binned wks_lyr_binned
notes wks_lyr_binned: 1963-1997 Unicon: wkslyr
notes wks_lyr_binned: 1998-present CPS: wkswork
notes wks_lyr_binned: Binned values exist for 1963-1975 in Unicon
notes wks_lyr_binned: Armed forces data only available for 1963-1975 data