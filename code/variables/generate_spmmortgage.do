********************************************************************************
* Supplemental Poverty Measure unit's tenure/mortgage status
********************************************************************************
gen byte spmmortgage = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spmmortgage = spmu_tenmortstatus
    }
    if tm(2019m1) <= $date {
        replace spmmortgage = spm_tenmortstatus
    }
}

lab var spmmortgage "SPM's mortgage status"
#delimit ;
lab def spm_mortgage
1 "Owner with mortgage"
2 "Owner w/o mortgage"
3 "Renter"
;
#delimit cr;
label value spmmortgage spmmortgage
notes spmmortgage: 2010-2018 SPM: spmu_tenmortstatus
notes spmmortgage: 2019-present CPS: spm_tenmortstatus
