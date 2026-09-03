********************************************************************************
* Supplemental Poverty Measure unit's state tax
********************************************************************************
gen byte spmstatetax = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spmstatetax = spmu_sttax
    }
    if tm(2019m1) <= $date {
        replace spmstatetax = spm_sttax
    }
}

lab var spmstatetax "SPM's state tax"
label value spmstatetax spmstatetax
notes spmstatetax: 2010-2018 SPM: spmu_sttax
notes spmstatetax: 2019-present CPS: spm_sttax
