********************************************************************************
* Supplemental Poverty Measure unit's school lunch subsidy
********************************************************************************
capture rename spm_schlunch orig_spm_schlunch
gen byte spm_schlunch = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spm_schlunch = spmu_schlunch
    }
    if tm(2019m1) <= $date {
        replace spm_schlunch = orig_spm_schlunch
    }
}

lab var spm_schlunch "SPM's school lunch subsidy"
label value spm_schlunch spm_schlunch
notes spm_schlunch: 2010-2018 SPM: spmu_schlunch
notes spm_schlunch: 2019-present: spm_schlunch
