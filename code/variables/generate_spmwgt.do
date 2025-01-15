********************************************************************************
* Supplemental Poverty Measure unit's weight
********************************************************************************
gen byte spmwgt = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace spmwgt = spm_weight
    }
}

lab var spmwgt "SPM's weight"
label value spmwgt spmwgt