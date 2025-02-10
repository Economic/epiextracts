*************************************************************************
* NAME: create_extracts
* DESC: Create uniform EPI extracts of CPS basic monthlies and May/ORG
* Called by master.do
*************************************************************************
global code code/
global uniconmarch /data/cps/march/unicon/
global censusmarchraw /data/cps/march/census/raw/
global censusmarchstata /data/cps/march/census/stata/
global codevars ${code}variables/
global suppdata suppdata/
global extracts extracts/

local minyear = 1962
local maxyear = 2009

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


* process all data
foreach year of numlist `minyear'(1)`maxyear' {

	* process annual march if necessary
	if 1962 <= `year' {
		* survey sample settings
		global marchcps = 1
		global monthlycps = 0
		global maycps = 0
		global earnerinfo = 0
		global basicfile = 0

		* for March CPS, use month=3 (march)
		global date = tm(`year'm3)

		if 1962 <= `year' & `year' <= 1997 {
			local inputpath ${uniconmarch}
			local inputfile unicon_march_`year'.dta
		}
		if 1998 <= `year' {
			local inputpath ${censusmarchstata}
			local inputfile cpsmarch_`year'.dta
		}

		* unzip and load source data into memory
		* 2014 is an exception with redesigned and traditional files:
		if `year' == 2014 {
			tempfile tmpdat_t tmpdat_r
			!unzip -p "`inputpath'cpsmarch_2014.dta.zip" > `tmpdat_r'
			!unzip -p "`inputpath'cpsmarch_2014_traditional.dta.zip" > `tmpdat_t'
			use `tmpdat_r', clear
			gen byte redesign = 1
			append using `tmpdat_t'
			replace redesign = 0 if redesign == .
		}
		else {
			tempfile tmpdat
			!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
			use `tmpdat', clear
		}

		* run key programs
		do ${code}sample_cpsbasic.do
		do ${code}generate_variables.do
		do ${code}keep_variables.do

		* save data
		compress
		notes drop _dta
		notes _dta: EPI CPS March Extracts, Version $dataversion
		label data "EPI CPS March Extracts, Version $dataversion"
		saveold ${extracts}epi_cpsmarch_`year'.dta, replace version(13)
	}
}


