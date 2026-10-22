********************************************************************************
* Weeks worked last year
********************************************************************************
gen byte weeksly = .

if $marchcps == 1 {
    * Unicon reports continuous weeks from 1976 (binned only for 1963-1975)
    if tm(1976m1) <= $date & $date <= tm(1997m12) {
        replace weeksly = wkslyr if 1 <= wkslyr & wkslyr <= 52
    }
    if tm(1998m1) <= $date {
        replace weeksly = wkswork if 1 <= wkswork & wkswork <= 52
    }
}

label var weeksly "Weeks worked last year"
notes weeksly: 1976-1997 Unicon: wkslyr
notes weeksly: 1998-present CPS: wkswork
notes weeksly: Zero weeks worked coded as missing
notes weeksly: See i_weeksly for intervalled values back to 1963
