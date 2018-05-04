do ${code}create_fakedatafordocs.do

* generate markdown documents for variables
foreach var of varlist _all {

	* determine if values will be displayed in documentation
	capture lab li `var'
	if _rc == 0 local dvalues displayvalues
	if _rc != 0 local dvalues nodisplayvalues
	di "`var' - `dvalues'"

	webdoc do ${code}docwrite.do `var' `dvalues', md raw nokeep
}
