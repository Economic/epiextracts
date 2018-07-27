* FILE: master.do
* DESC: master do-file to create EPI CPS Basic and ORG extracts
* run this to set up directory structure and load programs into memory
* run this do file in the project root containing master.do

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
global dataversion 0.3.3


*******************************************************************************
* DIRECTORY STRUCTURE
*******************************************************************************
* project directory paths relative project root containing master.do
global code code/
global extracts extracts/
global suppdata suppdata/
global codedocs ${code}docs/
global dictionaries ${code}dictionaries/
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
do ${code}utilities.do

* process the raw data and convert it to Stata format
* this is only necessary for additional months of data
*process_rawbasic, begin(2018m1) end(2018m5)

* create EPI's extracts from the processed raw data
* creates both basic monthly and ORG subsample
*create_extracts, begin(1973m1) end(2018m5)

* create documentation
*do ${codedocs}createdocs.do
