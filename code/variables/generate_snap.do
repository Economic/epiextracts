********************************************************************************
* Supplemental Poverty Measure unit's SNAP subsidy
********************************************************************************
gen byte snap = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace snap = spmu_snapsub
    }
    if tm(2019m1) <= $date {
        replace snap = spm_snapsub
    }
}

lab var snap "SPM's SNAP subsidy"
label value snap snap
notes snap: 2010-2018 SPM: spmu_snapsub
notes snap: 2019-present: spm_snapsub
