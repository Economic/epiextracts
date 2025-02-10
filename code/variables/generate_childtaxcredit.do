********************************************************************************
* Supplemental Poverty Measure unit's Additional Child Tax Credit
********************************************************************************
gen byte childtaxcredit = .

if $marchcps == 1 {
    if tm(2005m1) <= $date {
        replace childtaxcredit = ctc_crd
    }

}

lab var childtaxcredit "Child tax credit"
label value childtaxcredit childtaxcredit
notes childtaxcredit: 2005-present CPS: ctc_crd
