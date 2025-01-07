********************************************************************************
* Supplemental Poverty Measure unit's poverty threshold
********************************************************************************
gen byte spmpovcut = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace spmpovcut = spm_povthreshold
    }
}

lab var spmpovcut "SPM's poverty threshold"
label value spmpovcut spmpovcut