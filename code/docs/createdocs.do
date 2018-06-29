do ${codedocs}detailed_analysis.do

* load data for a given year to gather all variables
unzipfile ${extracts}epi_cpsbasic_2017.dta.zip, replace
use epi_cpsbasic_2017.dta, clear
tempfile basedata
save `basedata'
erase epi_cpsbasic_2017.dta
foreach var of varlist _all {
	if inlist("`var'","wage1","wage2","wage3","wage4","otcamt","otcrec","paidhre","weekpay") == 1 local group`var' income
	else local group`var' other
}

use `basedata', clear
foreach var of varlist _all {

	* use globals because we will reference these in docwrite.do
	global variableshortdesc ${codedocs}descriptions/shortdesc/
	global variablelongdesc ${codedocs}descriptions/longdesc/
	global variabledocs ${docs}variables/`group`var''/
	global variableimages ${variabledocs}images/
	global variablelevels ${variabledocs}levels/

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
	if _rc == 0 local image titleimage
	if _rc != 0 local image notitleimage

	use `basedata', clear
	webdoc do ${codedocs}docwrite.do `var' `dvalues' `detailed' `image', md raw nokeep
}
