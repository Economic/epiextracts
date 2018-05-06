* create docs for all variabels

* (1) do detailed analysis for some variables

* (2) create a markdown document for each variable consisting of
*		name of variable and variable label [pulled from data]
*		simple description [hand coded in variables/descriptions/]
*		variable notes
*		value labels

* load data for a given year and then loop over all variables
do ${codedocs}create_fakedatafordocs.do
tempfile fakedata
save `fakedata'

foreach var of varlist _all {

	* determine if values will be displayed in documentation
	capture lab li `var'
	if _rc == 0 local dvalues displayvalues
	if _rc != 0 local dvalues nodisplayvalues

	* determine if there is and detailed documentation
	capture webdoc do ${codedocs}`var'_detailed.do, md raw nokeep
	if _rc == 0 local detailed details
	if _rc != 0 local detailed nodetails
	di "`var' - `detailed'"

	* determine if there is a title image
	capture confirm file ${variableanalysis}`var'_titleimage.svg
	if _rc == 0 local image titleimage
	if _rc != 0 local image notitleimage
	di "`var' - `image'"

	use `fakedata', clear
	webdoc do ${codedocs}docwrite.do `var' `dvalues' `detailed' `image', md raw nokeep
}
