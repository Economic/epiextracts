********************************************************************************
* Supplemental Poverty Measure unit's school lunch subsidy
********************************************************************************
gen byte schlunch = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace schlunch = spm_schlunch
    }
}

lab var schlunch "SPM's school lunch subsidy"
label value schlunch schlunch