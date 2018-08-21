********************************************************************************
* Education: gradecom
********************************************************************************
gen gradecom = .
if tm(1973m1) <= $date & $date <= tm(1991m12) {
	replace gradecom = 1 if grdcom == 1
	replace gradecom = 0 if grdcom == 2
}
lab var gradecom "Completed highest grade attended"
lab define gradecom 0 "Not completed" 1 "Completed"
lab val gradecom gradecom
notes gradecom: Only available 1973-1991
notes gradecom: 1973-1991 Unicon: grdcom
