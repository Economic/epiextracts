********************************************************************************
* Supplemental Poverty Measure unit's family type (person level)
********************************************************************************
gen spmfamtype = .

if $marchcps == 1 {
	/*if tm(2010m1) <= $date & $date <= tm(2018m12) {
		replace famtype = famtyp
	}*/
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
notes spmfamtype: Type of family, SPM unit
notes spmfamtype: 2019-present March: spm_famtype