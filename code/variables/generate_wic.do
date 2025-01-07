********************************************************************************
* Supplemental Poverty Measure unit's WIC subsidy
********************************************************************************
gen byte wic = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace wic = spm_wicval
    }
}

lab var wic "SPM's WIC subsidy"
label value wic wic