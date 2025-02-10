********************************************************************************
* Supplemental Poverty Measure unit's poverty threshold
********************************************************************************
gen byte spmpovcut = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m1) {
        replace spmpovcut = spmu_povthreshold
    }
    if tm(2019m1) <= $date {
        replace spmpovcut = spm_povthreshold
    }
}

lab var spmpovcut "SPM's poverty threshold"
label value spmpovcut spmpovcut
notes spmpovcut: 2010-2018 SPM: spmu_povthreshold
notes spmpovcut: 2019-present: spm_povthreshold
