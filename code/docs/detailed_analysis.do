unzipfile ${extracts}epi_cpsbasic_2017.dta.zip, replace
use epi_cpsbasic_2017.dta, clear
tempfile basedata
save `basedata'
erase epi_cpsbasic_2017.dta
foreach var of varlist _all {
	if inlist("`var'","wage1","wage2","wage3","wage4","otcamt","otcrec","paidhre","weekpay") == 1 local group`var' income
	else local group`var' other
}

* CPS Basic analysis - single-year
local analysisvarlist cbsafips countyfips region division
local othervars year basicwgt statefips age

local year = 2017
unzipfile ${extracts}epi_cpsbasic_`year'.dta.zip, replace
use `analysisvarlist' `othervars' using epi_cpsbasic_`year'.dta, clear
erase epi_cpsbasic_`year'.dta
tempfile fulldata
save `fulldata'

foreach var of varlist `analysisvarlist' {
  * use globals because we will reference these in docwrite.do
  global variableshortdesc ${codedocs}descriptions/shortdesc/
  global variablelongdesc ${codedocs}descriptions/longdesc/
  global variabledocs ${docs}variables/`group`var''/
  global variableimages ${variabledocs}images/
  global variablelevels ${variabledocs}levels/
  use `fulldata', clear
  webdoc do ${codedocs}`var'_analysis.do, md raw nokeep
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}


* CPS Basic analysis - multi-year
local analysisvarlist wbho age educ emp
local othervars year basicwgt statefips

local counter = 0
forvalues year = 1973(1)2017 {
  if 1973 >= `year' & `year' <= 1975 local filename epi_cpsmay_`year'.dta
  if `year' >= 1976 local filename epi_cpsbasic_`year'.dta
	local counter = `counter' + 1
	unzipfile ${extracts}`filename'.zip, replace
	if `counter' == 1 use `analysisvarlist' `othervars' using `filename', clear
	else append using `filename', keep(`analysisvarlist' `othervars')
	erase `filename'
}
tempfile fulldata
save `fulldata'

foreach var of varlist `analysisvarlist' {
  * use globals because we will reference these in docwrite.do
  global variableshortdesc ${codedocs}descriptions/shortdesc/
  global variablelongdesc ${codedocs}descriptions/longdesc/
  global variabledocs ${docs}variables/`group`var''/
  global variableimages ${variabledocs}images/
  global variablelevels ${variabledocs}levels/
  use `fulldata', clear
  webdoc do ${codedocs}`var'_analysis.do, md raw nokeep
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}

* CPS ORG analysis
local analysisvarlist wage3
local othervars year orgwgt female
append_extracts, begin(1979m1) end(2017m12) sample(org) version(local) keeponly(`analysisvarlist' `othervars')
tempfile fulldata
save `fulldata'
foreach var of varlist `analysisvarlist' {
  * use globals because we will reference these in docwrite.do
  global variableshortdesc ${codedocs}descriptions/shortdesc/
  global variablelongdesc ${codedocs}descriptions/longdesc/
  global variabledocs ${docs}variables/`group`var''/
  global variableimages ${variabledocs}images/
  global variablelevels ${variabledocs}levels/
  use `fulldata', clear
  webdoc do ${codedocs}`var'_analysis.do, md raw nokeep
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}
