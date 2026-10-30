*******************************************************************************
* Household income percentiles 
*******************************************************************************
capture rename hhpct orig_hhpct
gen byte hhpct = .

if $marchcps == 1 {
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace hhpct = orig_hhpct
    }
    if tm(1998m1) <= $date {
        replace hhpct = hpctcut
    }
}

#delimit ;
lab def hhpct
0 "Group quarters"
1 "Bottom 5%"
2 "Second 5%"
3 "Third 5%"
4 "Fourth 5%"
5 "Fifth 5%"
6 "Sixth 5%"
7 "Seventh 5%"
8 "Eighth 5%"
9 "Ninth 5%"
10 "Tenth 5%"
11 "Eleventh 5%" 
12 "Twelfth 5%"
13 "Thirteenth 5%"
14 "Fourteenth 5%"
15 "Fifteenth 5%"
16 "Sixteenth 5%"
17 "Seventeenth 5%"
18 "Eighteenth 5%"
19 "Nineteenth 5%"
20 "Top 5%"
;
#delimit cr
label var hhpct "Household income percentiles"
label value hhpct hhpct 
notes hhpct: 1968-1997 Unicon: hhpct
notes hhpct: 1998-present CPS: hpctcut
