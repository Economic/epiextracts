********************************************************************************
* Supplemental Poverty Measure unit's SNAP subsidy
********************************************************************************
gen byte snap = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace snap = spm_snapsub
    }
}

lab var snap "SPM's SNAP subsidy"
label value snap snap