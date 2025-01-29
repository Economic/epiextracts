********************************************************************************
* Supplemental Poverty Measure unit's poverty rate
********************************************************************************
gen byte spmpov = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m1) {
        replace spmpov = spmu_poor
    }
    
    if tm(2019m1) <= $date {
        replace spmpov = spm_poor
    }
}

lab var spmpov "SPM's poverty rate"
label def spmpov 0 "Not in poverty" 1 "In poverty"
label value spmpov spmpov
notes spmpov: 2010-2018 SPM: spmu_pov
notes spmpov: 2019-present: spm_pov
