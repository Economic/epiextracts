********************************************************************************
* Supplemental Poverty Measure unit's poverty rate
********************************************************************************
gen byte spmpov = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace spmpov = spm_poor
    }
}

lab var spmpov "SPM's poverty rate"
label def spmpov 0 "Not in poverty" 1 "In poverty"
label value spmpov spmpov