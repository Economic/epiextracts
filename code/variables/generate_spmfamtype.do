********************************************************************************
* Supplemental Poverty Measure unit's family type (person level)
********************************************************************************
gen spmfamtype = .

if $marchcps == 1 {
	if tm(2010m1) <= $date & $date <= tm(2013m12) {
		replace spmfamtype = 1 if spmu_newfam == 1
		replace spmfamtype = 3 if spmu_newfam == 3
		replace spmfamtype = 4 if spmu_newfam == 2
		replace spmfamtype = 5 if spmu_newfam == 5
	}
	if tm(2014m1) <= $date & $date <= tm(2018m12) {
		replace spmfamtype = spmu_newfam
	}
	if tm(2019m1) <= $date {
		replace spmfamtype = spm_famtype
	}
}

#delimit ;
lab def spmfamtype
1 "Married couple family"
2 "Cohabitating partner"
3 "Female reference person"
4 "Male reference person"
5 "Unrelated individuals"
;
#delimit cr;
lab val spmfamtype spmfamtype
lab var spmfamtype "SPM's family type (person level)"
notes spmfamtype: 2010-2014 "Unrelated individuals" includes individuals in new SPM unit
notes spmfamtype: 2010-2019 SPM: spmu_newfam
notes spmfamtype: 2019-present CPS: spm_famtype
