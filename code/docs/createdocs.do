do ${codedocs}detailed_analysis.do
do ${codedocs}add_misc.do

* create variable index page
webdoc do ${codedocs}variableindex.do, raw nokeep init(${docs}variables/index.md) replace

* create variable-specific pages
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

* load data for a given year to gather all variables
load_epiextracts, begin(2023m1) end(2023m12) sample(org) version(local)
keep if _n == 1
tempfile basedata
save `basedata'

* create pages
foreach var of varlist _all {

	if "`group`var''" == "" {
		di _n "No group assigned to `var'"
		error 1
	}

	* use globals because we will reference these in docwrite.do
	global variableshortdesc ${codedocs}descriptions/shortdesc/
	global variablelongdesc ${codedocs}descriptions/longdesc/
	global variableavailability ${codedocs}descriptions/availability/
	global variabledocs ${docs}variables/`group`var''/
	global variableimages ${variabledocs}images/
	global variablecode ${variabledocs}code/

	* create variable page
	use `basedata', clear
	webdoc do ${codedocs}docwrite.do `var', raw nokeep init(${variabledocs}`var'.md) replace
}
