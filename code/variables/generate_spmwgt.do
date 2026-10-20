********************************************************************************
* Supplemental Poverty Measure unit's weight
********************************************************************************
gen byte spmwgt = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spmwgt = spmu_weight / 100
    }
    if tm(2019m1) <= $date {
        replace spmwgt = spm_weight / 100
    }
}

lab var spmwgt "SPM's weight"
label value spmwgt spmwgt
notes spmwgt: 2010-2018 SPM: spmu_weight
notes spmwgt: 2019-present: spm_weight
