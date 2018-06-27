* CPS ORG analysis
local analysisvarlist wage3
local othervars year orgwgt female

local counter = 0
forvalues year = 1979(1)2017 {
	local counter = `counter' + 1
	unzipfile ${extracts}epi_cpsorg_`year'.dta.zip, replace
	if `counter' == 1 use `analysisvarlist' `othervars' using epi_cpsorg_`year'.dta, clear
	else append using epi_cpsorg_`year'.dta, keep(`analysisvarlist' `othervars')
	erase epi_cpsorg_`year'.dta
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



* CPS Basic analysis
local analysisvarlist countyfips age educ wbho emp region division
local othervars year basicwgt statefips

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
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}
