* FILE: master.do
* DESC: master do-file for EPI CPS Basic/ORG/May extracts and documentation.
* It only sets up the directory structure & loads programs into memory.
* It is designed to be run from the project root containing this do-file.
*
* See the example function calls at the bottom of this do-file to create
* the extracts or documentation.
*
* Documentation on the extracts and how to use the data and code are
* available at http://microdata.epi.org
*
* In order for the code to run, you will need some user-written Stata programs:
*
* ssc install webdoc, replace
* ssc install gtools
* ssc install ashell, replace
* ssc install moreobs, replace
* ssc install maptile, replace
* ssc install spmap, replace
* ssc install labutil, replace
* maptile_install using "http://files.michaelstepner.com/geo_statehex.zip"
* maptile_install using "http://files.michaelstepner.com/geo_cbsa2013.zip"
* maptile_install using "http://files.michaelstepner.com/geo_state.zip"
* maptile_install using "http://files.michaelstepner.com/geo_county2014.zip"
* 
* you also need the python module tabulate: https://pypi.org/project/tabulate/
*
* The extracts and documentation use the CPI-U-RS to adjust for inflation when 
* trimming wage variables. EPI's CPI stata package is called on to load this data.
* This package is available here: https://github.com/Economic/cpi

*******************************************************************************
* PRELIMINARIES
*******************************************************************************
clear all
set more off
set trace off


*******************************************************************************
* DATA VERSION
*******************************************************************************
* The version is saved in the dataset labels and notes.
* Both the version and the latest month of data are set in config/release.yml,
* the single source shared with the docs, the Quarto site and the Makefile.
file open release using config/release.yml, read text
file read release line
while r(eof) == 0 {
	* skip comments; split "key: value" lines
	if !regexm(`"`line'"', "^ *#") & strpos(`"`line'"', ":") > 0 {
		local key = strtrim(substr(`"`line'"', 1, strpos(`"`line'"', ":") - 1))
		local value = strtrim(substr(`"`line'"', strpos(`"`line'"', ":") + 1, .))
		if "`key'" == "version" global dataversion `value'
		if "`key'" == "latestdata" global latestdata `value'
	}
	file read release line
}
file close release
assert "$dataversion" != "" & "$latestdata" != ""


*******************************************************************************
* DIRECTORY STRUCTURE
*******************************************************************************
* project directory paths relative project root containing master.do
global code code/
global extracts extracts/
global suppdata suppdata/
global codedocs ${code}docs/
global codevars ${code}variables/
global dictionaries ${code}dictionaries/
global reweights ${code}dictionaries/reweights/

* path names for docs
global docs documentation/docs/

* CPS raw data directories  - only necessary for converting raw to Stata format
* Census data that needs to be converted to Stata
global censusbasicraw /data/cps/basic/census/raw/
global censusbasicstata /data/cps/basic/census/stata/
global censusmarchraw /data/cps/march/census/raw/
global censusmarchstata /data/cps/march/census/stata/
* Unicon data already in Stata format
global uniconbasic /data/cps/basic/unicon/
global uniconmay /data/cps/may/unicon/
global uniconmarch /data/cps/march/unicon/
global uniconorg /data/cps/org/unicon/


*******************************************************************************
* LOAD KEY PROGRAMS INTO MEMORY
*******************************************************************************
* this just loads programs into memory
adopath ++ ${code}ado


*******************************************************************************
* EXAMPLE FUNCTIONS
*******************************************************************************
* process the raw data and convert it to Stata format
* this is only necessary for additional months of data
* process_rawmarch, begin(1998) end(2018)
*process_rawbasic, begin(2025m9) end($latestdata)

* create EPI's extracts from the processed raw data
* creates both basic monthly and ORG subsample
create_extracts, begin(2024m1) end($latestdata)
do ${code}tc_fix.do

* create documentation
* do ${codedocs}createdocs.do
