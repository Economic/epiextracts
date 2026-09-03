********************************************************************************
* Supplemental Poverty Measure unit's WIC subsidy
********************************************************************************
gen byte spmwic = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spmwic = spmu_wicval
    }
    if tm(2019m1) <= $date {
        replace spmwic = spm_wicval
    }
}

lab var spmwic "SPM's WIC subsidy"
label value spmwic spmwic
notes spmwic: 2010-2018 SPM: spmu_wicval
notes spmwic: 2019-present: spm_wicval
