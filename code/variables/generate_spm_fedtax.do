********************************************************************************
* Supplemental Poverty Measure unit's federal tax
********************************************************************************
capture rename spm_fedtax oldspm_fedtax
gen byte spm_fedtax = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace spm_fedtax = spmu_fedtax
    }
    if tm(2019m1) <= $date {
        replace spm_fedtax = spm_fedtax
    }
}

lab var spm_fedtax "SPM federal tax"
label value spm_fedtax spm_fedtax
notes spm_fedtax: 2010-2018 SPM: spmu_fedtax
notes spm_fedtax: 2019-present CPS: spm_fedtax
