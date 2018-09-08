********************************************************************************
* CBSA
********************************************************************************
gen cbsafips = .
if tm(2004m5) <= $date {
	replace cbsafips = gtcbsa
}
lab var cbsafips "Core Based Statistical Area - FIPS code"
lab def cbsafips 0 "Not identified"
lab val cbsafips cbsafips
notes cbsafips: 2004m5-present, CPS: gtcbsa
notes cbsafips: Not consistent over time
