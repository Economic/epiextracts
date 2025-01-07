********************************************************************************
* Supplemental Poverty Measure unit's federal tax
********************************************************************************
gen byte fedtax = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace fedtax = spm_fedtax
    }
}

lab var fedtax "SPM federal tax"
label value fedtax fedtax