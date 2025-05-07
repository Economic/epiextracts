********************************************************************************
* Supplemental Poverty Measure unit's SNAP subsidy
********************************************************************************
gen byte spm_snap = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spm_snap = spmu_snapsub
    }
    if tm(2019m1) <= $date {
        replace spm_snap = spm_snapsub
    }
}

lab var spm_snap "SPM's SNAP subsidy"
label value spm_snap spm_snap
notes spm_snap: 2010-2018 SPM: spmu_snapsub
notes spm_snap: 2019-present: spm_snapsub
