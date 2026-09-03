********************************************************************************
* Supplemental Poverty Measure unit's school lunch subsidy
********************************************************************************
gen byte spmschlunch = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spmschlunch = spmu_schlunch
    }
    if tm(2019m1) <= $date {
        replace spmschlunch = spm_schlunch
    }
}

lab var spmschlunch "SPM's school lunch subsidy"
label value spmschlunch spmschlunch
notes spmschlunch: 2010-2018 SPM: spmu_schlunch
notes spmschlunch: 2019-present: spm_schlunch
