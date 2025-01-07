********************************************************************************
* Supplemental Poverty Measure unit's state tax
********************************************************************************
gen byte statetax = .

if $marchcps == 1 {
    if tm(2019m1) <= $date {
        replace statetax = spm_sttax
    }
}

lab var statetax "SPM's state tax"
label value statetax statetax