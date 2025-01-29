********************************************************************************
* Supplemental Poverty Measure unit's WIC subsidy
********************************************************************************
gen byte wic = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace wic = spmu_wicval
    }
    if tm(2019m1) <= $date {
        replace wic = spm_wicval
    }
}

lab var wic "SPM's WIC subsidy"
label value wic wic
notes wic: 2010-2018 SPM: spmu_wicval
notes wic: 2019-present: spm_wicval
