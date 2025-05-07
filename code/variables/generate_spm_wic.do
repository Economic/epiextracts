********************************************************************************
* Supplemental Poverty Measure unit's WIC subsidy
********************************************************************************
gen byte spm_wic = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spm_wic = spmu_wicval
    }
    if tm(2019m1) <= $date {
        replace spm_wic = spm_wicval
    }
}

lab var spm_wic "SPM's WIC subsidy"
label value spm_wic spm_wic
notes spm_wic: 2010-2018 SPM: spmu_wicval
notes spm_wic: 2019-present: spm_wicval
