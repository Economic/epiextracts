********************************************************************************
* Supplemental Poverty Measure unit's state tax
********************************************************************************
gen byte spm_statetax = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spm_statetax = spmu_sttax
    }
    if tm(2019m1) <= $date {
        replace spm_statetax = spm_sttax
    }
}

lab var spm_statetax "SPM's state tax"
label value spm_statetax spm_statetax
notes spm_statetax: 2010-2018 SPM: spmu_sttax
notes spm_statetax: 2019-present CPS: spm_sttax
