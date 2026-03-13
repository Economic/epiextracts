*************************************************************************
* NAME: create_extracts
* DESC: Create uniform EPI extracts of CPS basic monthlies and May/ORG
* Called by master.do
*************************************************************************
global code code/
global censusbasicraw /data/cps/basic/census/raw/
global censusbasicstata /data/cps/basic/census/stata/
global codevars ${code}variables/
global suppdata suppdata/
global extracts extracts/
global dictionaries ${code}dictionaries/
global dataversion 2026.3.11


* deal with dates
local begindate = tm(2026m1)
local enddate = tm(2026m1)
local minyear = year(dofm(`begindate'))
local maxyear = year(dofm(`enddate'))

* state codes
import delimited using ${suppdata}state_geocodes.csv, clear varnames(1)
labmask statefips, val(stateabb)
labmask statecensus, val(stateabb)
labmask division, val(divisionname)
labmask region, val(regionname)
drop *name
* start ridiculous hack to add value labels for these variables
* after merging them later in epi_cpsbasic_geog.do
foreach var of varlist statefips statecensus {
	gen `var'_alt = `var'
	lab val `var'_alt `var'
}
keep statefips* statecensus* division* region*
tempfile stategeocodes
save `stategeocodes'
global stategeocodes `stategeocodes'

foreach date of numlist `begindate'(1)`enddate' {
	local year = year(dofm(`date'))
	local month = month(dofm(`date'))
	local monthlist`year' `monthlist`year'' `month'
}


* process all data
foreach year of numlist `minyear'(1)`maxyear' {

	global marchcps = 0
	global monthlycps = 1
	global maycps = 0
	global earnerinfo = 0
	global basicfile = 0
	* start a counter to help determine if we have a full year of data
	local counter = 0
	foreach month of numlist `monthlist`year'' {
		local counter = `counter' + 1
		* define current month
		global date = tm(`year'm`month')
		* indicator for using basic monthly file
		global basicfile = 1

        local inputpath ${censusbasicstata}
		local inputfile cps_`year'_`month'b.dta
		

		* unzip and load source data into memory
		tempfile tmpdat
		!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
		use `tmpdat', clear
		* run key basic/org programs
		do ${code}sample_cpsbasic.do
		do ${code}generate_variables.do
		do ${code}keep_variables.do
		* limit sample to certain variables for debugging
		if "`keeponly'" ~= "" keep year month minsamp basicwgt orgwgt `keeponly'
		* save basic monthly extract
		tempfile basic_month`month'
		save `basic_month`month''
		
		compress
		notes drop _dta
		notes _dta: EPI CPS Basic Monthly Extracts, Version $dataversion
		label data "EPI CPS Basic Monthly Extracts, Version $dataversion"
		saveold ${extracts}epi_cpsbasic_`year'_`month'b.dta, replace version(13)
	}
}

