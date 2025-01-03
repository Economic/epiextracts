********************************************************************************
* Supplemental Poverty Measure unit's tenure/mortgage status
********************************************************************************
gen byte mortgage = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace mortgage = spmu_tenmortstatus
    }
    if tm(2019m1) <= $date {
        replace mortgage = spm_tenmortstatus
    }
}

lab var mortgage "SPM's mortgage status"
#delimit ;
lab def mortgage
1 "Owner with mortgage"
2 "Owner w/o mortgage"
3 "Renter"
;
#delimit cr;
label value mortgage mortgage
notes mortgage: 2010-2018 SPM: spmu_tenmortstatus
notes mortgage: 2019-present CPS: spm_tenmortstatus
