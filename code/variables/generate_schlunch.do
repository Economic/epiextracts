********************************************************************************
* Supplemental Poverty Measure unit's school lunch subsidy
********************************************************************************
gen byte schlunch = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace schlunch = spmu_schlunch
    }
    if tm(2019m1) <= $date {
        replace schlunch = spm_schlunch
    }
}

lab var schlunch "SPM's school lunch subsidy"
label value schlunch schlunch
notes schlunch: 2010-2018 SPM: spmu_schlunch
notes schlunch: 2019-present: spm_schlunch
