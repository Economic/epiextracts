do ${codedocs}detailed_analysis.do

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
unzipfile ${extracts}epi_cpsbasic_2017.dta.zip, replace
use epi_cpsbasic_2017.dta, clear
tempfile basedata
save `basedata'
erase epi_cpsbasic_2017.dta

use `basedata', clear
foreach var of varlist _all {

	if "`group`var''" == "" {
		di _n "No group assigned to `var'"
		error 1
	}

	* use globals because we will reference these in docwrite.do
	global variableshortdesc ${codedocs}descriptions/shortdesc/
	global variablelongdesc ${codedocs}descriptions/longdesc/
	global variabledocs ${docs}variables/`group`var''/
	global variableimages ${variabledocs}images/
	global variablelevels ${variabledocs}levels/
	global variablecode ${variabledocs}code/

	* copy variable code to variablecode directory
	copy ${codevars}generate_`var'.do ${variablecode}generate_`var'.do, replace

	* determine if values will be displayed in documentation
	* if so, create .csv file of value labels
	use `basedata', clear
	local labelname: value label `var'
	if "`labelname'" == "" local dvalues nodisplayvalues
	if "`labelname'" != "" {
		local dvalues displayvalues
		valuelabel2csv using ${variablelevels}`var'.csv, label(`labelname') replace
	}

	* determine if there is and detailed documentation
	capture confirm file ${variablelongdesc}`var'_longdesc.md
	if _rc == 0 local detailed details
	if _rc != 0 local detailed nodetails

	* determine if there is a title image
	capture confirm file ${variableimages}`var'_titleimage.svg
	if _rc == 0 {
		local image titleimage
		copy ${codedocs}`var'_analysis.do ${variablecode}`var'_analysis.do, replace
	}
	if _rc != 0 local image notitleimage

	use `basedata', clear
	webdoc do ${codedocs}docwrite.do `var' `dvalues' `detailed' `image', md raw nokeep
}
