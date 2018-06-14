* create docs for all variabels

* (1) do detailed analysis for some variables

* (2) create a markdown document for each variable consisting of
*		name of variable and variable label [pulled from data]
*		simple description [hand coded in variables/descriptions/]
*		variable notes
*		value labels

* load data for a given year and then loop over all variables
unzipfile ${extracts}epi_cpsbasic_2017.dta.zip, replace
use epi_cpsbasic_2017.dta, clear
tempfile basedata
save `basedata'
erase epi_cpsbasic_2017.dta

foreach var of varlist _all {

	* determine if values will be displayed in documentation
	use `basedata', clear
	local labelname: value label `var'
	if "`labelname'" == "" local dvalues nodisplayvalues
	if "`labelname'" != "" {
		local dvalues displayvalues
		valuelabel2csv using ${variablelevels}`var'.csv, label(`labelname') replace
	}

	* determine if there is and detailed documentation
	* we should really move this into a prior loop to save time
	* 	(1) load all necessary data
	*		(2) do the analysis over certain variables
	*		(3) save each variables detailed md file
	* 	(4) then this loop should confirm/deny existence of detailed .md
	*capture webdoc do ${codedocs}`var'_detailed.do, md raw nokeep
	*if _rc == 0 local detailed details
	*if _rc != 0 local detailed nodetails
	local detailed nodetails

	* determine if there is a title image
	capture confirm file ${variableanalysis}`var'_titleimage.svg
	if _rc == 0 local image titleimage
	if _rc != 0 local image notitleimage

	use `basedata', clear
	webdoc do ${codedocs}docwrite.do `var' `dvalues' `detailed' `image', md raw nokeep
}
