********************************************************************************
* Supplemental Poverty Measure unit's federal tax
********************************************************************************
gen byte spmfedtax = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spmfedtax = spmu_fedtax
    }
    if tm(2019m1) <= $date {
        replace spmfedtax = spm_fedtax
    }
}

lab var spmfedtax "SPM federal tax"
label value spmfedtax spmfedtax
notes spmfedtax: 2010-2018 SPM: spmu_fedtax
notes spmfedtax: 2019-present CPS: spm_fedtax
