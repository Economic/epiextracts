*******************************************************************************
* Union represented: member or covered
*******************************************************************************
gen byte union = .
replace union = 0 if unmem ~= . | uncov ~= .
replace union = 1 if unmem == 1
replace union = 1 if uncov == 1
* recode as missing in may before 1977 because no union coverage available
if $monthlycps == 0 & $maycps == 1 {
	if $date <= tm(1976m12) {
		replace union = .
 	}
}
* recode as missing in basic before 1984 because no union coverage available
if $monthlycps == 1 & $maycps == 0 & $earnerinfo == 1 & $basicfile == 1 {
	if $date <= tm(1984m1) {
		replace union = .
	}
}
* recode as missing in org before 1983 because no union coverage available
if $monthlycps == 1 & $maycps == 0 & $earnerinfo == 1 & $basicfile == 0 {
	if $date <= tm(1983m1) {
		replace union = .
	}
}
lab var union "Represented by a union as a member or covered by contract"
lab def union 1 "Union represented" 0 "Not union represented"
lab val union union
notes union: Not defined when union coverage is missing
notes union: Only available in 1977-1981 May, 1983-present ORG
notes union: Not available on 1976-1983 basic monthly files
notes union: Not available prior to 1977 or in 1982
notes union: Derived from unmem and uncov
