* this do file will call educ_detailed.do, wbho_detailed.do, etc.

* basic analysis
local analysisvarlist educ /*wbho*/
local othervars year basicwgt age

local counter = 0
forvalues year = 1976(1)2017 {
	local counter = `counter' + 1
	unzipfile ${extracts}epi_cpsbasic_`year'.dta.zip, replace
	if `counter' == 1 use `analysisvarlist' `othervars' using epi_cpsbasic_`year'.dta, clear
	else append using epi_cpsbasic_`year'.dta, keep(`analysisvarlist' `othervars')
	erase epi_cpsbasic_`year'.dta
}
tempfile fulldata
save `fulldata'

foreach var of varlist `analysisvarlist' {
  use `fulldata', clear
  webdoc do ${codedocs}`var'_analysis.do, md raw nokeep
}


* org analysis
