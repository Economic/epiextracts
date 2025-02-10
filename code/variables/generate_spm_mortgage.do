********************************************************************************
* Supplemental Poverty Measure unit's tenure/mortgage status
********************************************************************************
gen byte spm_mortgage = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spm_mortgage = spmu_tenmortstatus
    }
    if tm(2019m1) <= $date {
        replace spm_mortgage = spm_tenmortstatus
    }
}

lab var spm_mortgage "SPM's mortgage status"
#delimit ;
lab def spm_mortgage
1 "Owner with mortgage"
2 "Owner w/o mortgage"
3 "Renter"
;
#delimit cr;
label value spm_mortgage spm_mortgage
notes spm_mortgage: 2010-2018 SPM: spmu_tenmortstatus
notes spm_mortgage: 2019-present CPS: spm_tenmortstatus
