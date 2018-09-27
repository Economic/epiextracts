********************************************************************************
* cbsasize: size of CBSA metropolitan area
********************************************************************************
gen cbsasize = .
if tm(2004m5) <= $date {
	replace cbsasize = gtcbsasz
}
lab var cbsasize "Size of metropolitan area (CBSA)"
#delimit ;
lab def cbsasize
0 "Not identified or nonmetropolitan"
2	"100,000 - 249,999"
3	"250,000 - 499,999"
4	"500,000 - 999,999"
5	"1,000,000 - 2,499,999"
6	"2,500,000 - 4,999,999"
7	"5,000,000+"
;
#delimit cr;
lab val cbsasize cbsasize
notes cbsasize: 2004m5-present CPS: gtcbsasz
