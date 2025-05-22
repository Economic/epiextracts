*******************************************************************************
* SPM unit's earned income tax credit
*******************************************************************************
gen byte spmeitc = .

if $marchcps == 1 {
	if tm(2010m1) <= $date & $date <= tm(2018m12) {
		replace spmeitc = spmu_eitc
	}  
	if tm(2019m1) <= $date {
		replace spmeitc = spm_eitc
	}  
}

lab var spmeitc "SPM unit's earned income tax credit"
lab val spmeitc spmeitc
notes spmeitc: Available 2010-present
notes spmeitc: 2010-2018 SPM: spmu_eitc
notes spmeitc: 2019-present CPS: spm_eitc
