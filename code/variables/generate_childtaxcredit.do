********************************************************************************
* Supplemental Poverty Measure unit's Additional Child Tax Credit
********************************************************************************
gen byte childtaxcredit = .

if $marchcps == 1 {
    if tm(2010m1) <= $date & $date <= tm(2018m12) {
        replace childtaxcredit = spmu_actc
    }
    if tm(2019m1) <= $date {
        replace childtaxcredit = spm_actc
    }
}

lab var childtaxcredit "SPM's child tax credit"
label value childtaxcredit childtaxcredit
notes childtaxcredit: 2010-2018 SPM: spmu_actc
notes childtaxcredit: 2019-present CPS: spm_actc
