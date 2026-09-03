********************************************************************************
* Supplemental Poverty Measure unit's SNAP subsidy
********************************************************************************
gen byte spmsnap = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spmsnap = spmu_snapsub
    }
    if tm(2019m1) <= $date {
        replace spmsnap = spm_snapsub
    }
}

lab var spmsnap "SPM's SNAP subsidy"
label value spmsnap spmsnap
notes spmsnap: 2010-2018 SPM: spmu_snapsub
notes spmsnap: 2019-present: spm_snapsub
