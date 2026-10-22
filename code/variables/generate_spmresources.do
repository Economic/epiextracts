********************************************************************************
* Supplemental Poverty Measure unit's resources
********************************************************************************
gen byte spmresources = .

if $marchcps == 1 {
    * SPM research files (merged in process_rawmarch) use spmu_ prefix
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spmresources = spmu_resources
    }
    * public use files carry SPM variables directly from 2019
    if tm(2019m1) <= $date {
        replace spmresources = spm_resources
    }
}

lab var spmresources "SPM's resources"
notes spmresources: 2010-2018 SPM: spmu_resources
notes spmresources: 2019-present: spm_resources
