webdoc init ${variableanalysis}wbho_detailed, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

forvalues year = 1979/2017 {
	unzipfile ${ceprdata}cepr_org_`year'.zip
	if `year' == 1979 use year orgwgt wbho cepr_org_`year', clear
	if `year' == 1979 else append using cepr_org_`year', keep(year orgwgt wbho)
}
stop
gen white = wbho == 1
gen black = wbho == 2
gen hispanic = wbho == 3
gen other = wbho == 4

webdoc put well, this is my detailed analysis for wbho
