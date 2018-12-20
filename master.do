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
global dataversion 0.5.6


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
* Unicon data already in Stata format
global uniconbasic /data/cps/basic/unicon/
global uniconorg /data/cps/org/unicon/
global uniconmay /data/cps/may/unicon/


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
*process_rawbasic, begin(1994m1) end(2018m11)

* create EPI's extracts from the processed raw data
* creates both basic monthly and ORG subsample
*create_extracts, begin(1973m1) end(2018m11)

* create documentation
*do ${codedocs}createdocs.do
