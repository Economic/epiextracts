* basic analysis
local analysisvarlist educ wbho emp region
local othervars year basicwgt age statefips

local counter = 0
forvalues year = 1979(1)2017 {
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
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}

* org analysis
