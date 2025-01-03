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
local analysisvarlist wbhaom wbhom statefips statecensus cbsafips countyfips region division
local othervars year basicwgt statefips age

load_epiextracts, begin(2024m1) end(2024m12) sample(basic) version(local) keep(`analysisvarlist' `othervars')
tempfile fulldata
save `fulldata'

foreach var of varlist `analysisvarlist' {
  * use globals because we will reference these in docwrite.do
  global variableshortdesc ${codedocs}descriptions/shortdesc/
  global variablelongdesc ${codedocs}descriptions/longdesc/
  global variabledocs ${docs}variables/`group`var''/
  global variableimages ${variabledocs}images/
  use `fulldata', clear
  webdoc do ${codedocs}analysis/`var'_analysis.do, raw nokeep init(${variablelongdesc}`var'_longdesc.md) replace
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}


* CPS Basic 76-present + May 73-75 analysis - multi-year
local analysisvarlist veteran multjob ptecon selfemp selfinc pubsec pubst pubfed publoc nilf lfstat unemp schenrl emp hispanic wbho wbhao wbo_only wbho_only age educ
local othervars year basicwgt finalwgt female

load_epiextracts, begin(1973m1) end(1975m12) sample(may) version(local) keep(`analysisvarlist' `othervars')
tempfile maydata
save `maydata'
load_epiextracts, begin(1976m1) end(2024m12) sample(basic) version(local) keep(`analysisvarlist' `othervars')
append using `maydata'
tempfile fulldata
save `fulldata'
foreach var of varlist `analysisvarlist' {
  * use globals because we will reference these in docwrite.do
  global variableshortdesc ${codedocs}descriptions/shortdesc/
  global variablelongdesc ${codedocs}descriptions/longdesc/
  global variabledocs ${docs}variables/`group`var''/
  global variableimages ${variabledocs}images/
  use `fulldata', clear
	webdoc do ${codedocs}analysis/`var'_analysis.do, raw nokeep init(${variablelongdesc}`var'_longdesc.md) replace
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}


* CPS ORG/May analysis for wage variables
local analysisvarlist otcrec tc_weekpay a_earnhour a_weekpay paidhre wage wageotc wage_noadj
local othervars year orgwgt female age basicwgt
load_epiextracts, begin(1979m1) end(2024m12) sample(org) version(local) keep(`analysisvarlist' `othervars')
tempfile orgdata
save `orgdata'
load_epiextracts, begin(1973m1) end(1978m12) sample(may) version(local) keep(`analysisvarlist' `othervars')
append using `orgdata'
tempfile fulldata
save `fulldata'
foreach var of varlist `analysisvarlist' {
  * use globals because we will reference these in docwrite.do
  global variableshortdesc ${codedocs}descriptions/shortdesc/
  global variablelongdesc ${codedocs}descriptions/longdesc/
  global variabledocs ${docs}variables/`group`var''/
  global variableimages ${variabledocs}images/
  use `fulldata', clear
	webdoc do ${codedocs}analysis/`var'_analysis.do, raw nokeep init(${variablelongdesc}`var'_longdesc.md) replace
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}


* CPS ORG analysis for unions
local analysisvarlist union unmem
local othervars year age female selfemp
load_epiextracts, begin(1983m1) end(2024m12) sample(org) version(local) keep(`analysisvarlist' `othervars')
tempfile orgdata
save `orgdata'

load_epiextracts, begin(1973m1) end(1981m12) sample(may) version(local) keep(`analysisvarlist' `othervars')
append using `orgdata'
tempfile fulldata
save `fulldata'

foreach var of varlist `analysisvarlist' {
  * use globals because we will reference these in docwrite.do
  global variableshortdesc ${codedocs}descriptions/shortdesc/
  global variablelongdesc ${codedocs}descriptions/longdesc/
  global variabledocs ${docs}variables/`group`var''/
  global variableimages ${variabledocs}images/
  use `fulldata', clear
	webdoc do ${codedocs}analysis/`var'_analysis.do, raw nokeep init(${variablelongdesc}`var'_longdesc.md) replace
	* if longdesc output is empty, delete
	ashell du -k "${variablelongdesc}`var'_longdesc.md" | cut -f1
	if `r(o1)' == 0 erase "${variablelongdesc}`var'_longdesc.md"
}
