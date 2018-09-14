* variable-group definitions
import delimited using ${codedocs}variables_groups.csv, clear varnames(1)
tempfile groups
save `groups'
local N = _N
forvalues i = 1 / `N' {
	use `groups', clear
	keep if _n == `i'
	local var: di varname
	local group`var': di group
}


* CPS Basic analysis - single-year
local analysisvarlist statefips statecensus cbsafips countyfips region division
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
  webdoc do ${codedocs}`var'_analysis.do, md raw nokeep init(${variablelongdesc}`var'_longdesc) replace
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}


* CPS Basic 76-present + May 73-75 analysis - multi-year
local analysisvarlist multjob ptecon selfemp selfinc pubsec pubst pubfed publoc nilf lfstat unemp schenrl emp wbho age educ
local othervars year basicwgt finalwgt female

append_extracts, begin(1973m1) end(1975m12) sample(may) version(local) keep(`analysisvarlist' `othervars')
tempfile maydata
save `maydata'
append_extracts, begin(1976m1) end(2017m12) sample(basic) version(local) keep(`analysisvarlist' `othervars')
append using `maydata'
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
	webdoc do ${codedocs}`var'_analysis.do, md raw nokeep init(${variablelongdesc}`var'_longdesc) replace
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}


* CPS ORG/May analysis for wage variables
local analysisvarlist a_earnhour a_weekpay paidhre wage wageotc wage_noadj
local othervars year orgwgt female age basicwgt
append_extracts, begin(1979m1) end(2017m12) sample(org) version(local) keep(`analysisvarlist' `othervars')
tempfile orgdata
save `orgdata'
append_extracts, begin(1973m1) end(1978m12) sample(may) version(local) keep(`analysisvarlist' `othervars')
append using `orgdata'
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
	webdoc do ${codedocs}`var'_analysis.do, md raw nokeep init(${variablelongdesc}`var'_longdesc) replace
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}


* CPS ORG analysis for unions
local analysisvarlist union unmem
local othervars year age female selfemp
append_extracts, begin(1983m1) end(2017m12) sample(org) version(local) keep(`analysisvarlist' `othervars')
tempfile orgdata
save `orgdata'

append_extracts, begin(1973m1) end(1981m12) sample(may) version(local) keep(`analysisvarlist' `othervars')
append using `orgdata'
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
	webdoc do ${codedocs}`var'_analysis.do, md raw nokeep init(${variablelongdesc}`var'_longdesc) replace
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}
