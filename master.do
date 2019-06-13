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
* ssc install ashell, replace
* ssc install moreobs, replace
* ssc install maptile, replace
* ssc install spmap, replace
* maptile_install using "http://files.michaelstepner.com/geo_statehex.zip"
* maptile_install using "http://files.michaelstepner.com/geo_cbsa2013.zip"
* maptile_install using "http://files.michaelstepner.com/geo_state.zip"
* maptile_install using "http://files.michaelstepner.com/geo_county2014.zip"

*******************************************************************************
* PRELIMINARIES
*******************************************************************************
clear all
set more off
set trace off


*******************************************************************************
* DATA VERSION
*******************************************************************************
* The version is saved in the dataset labels and notes
global dataversion 0.6.9


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
global docs docs/

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
*process_rawmarch, begin(1998) end(2018)
*process_rawbasic, begin(1994m1) end(2019m4)

* create EPI's extracts from the processed raw data
* creates both basic monthly and ORG subsample
*create_extracts, begin(1962m1) end(2019m4)

* create documentation
*do ${codedocs}createdocs.do
