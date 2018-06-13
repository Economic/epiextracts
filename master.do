* FILE: master.do
* DESC: master do-file to create EPI CPS Basic and ORG extracts
clear all
set more off
set trace off

* Data Version
* This version is saved on data
global dataversion 0.1

* project directory structure
* set your stata working directory to the project root containing master.do
global code code/
global extracts extracts/
global suppdata suppdata/
global codedocs ${code}docs/
global dictionaries ${code}dictionaries/

* load key programs
do ${code}utilities.do

* CPS raw data directories  - only necessary for converting raw to Stata format
* Unicon data already in Stata format
global uniconbasic /data/cps/basic/unicon/
global uniconorg /data/cps/org/unicon/
global uniconmay /data/cps/may/unicon/
* Census data needs to be converted
global censusbasicraw /data/cps/basic/census/raw/
global censusbasicstata /data/cps/basic/census/stata/

* CEPR data: temporary for doc testing
global ceprdata /data/cps/org/cepr/

* path names for docs
global docs docs/
global variabledocs ${docs}variables/
global variabledesc ${docs}variables/descriptions/
global variableanalysis ${docs}variables/analysis/
global variablelevels ${docs}variables/levels/


* process the raw data and convert it to Stata format
* this is only necessary for additional months of data
*process_rawbasic, begin("2003m1") end("2004m1")

* create EPI's extracts from the processed raw data
* creates both basic monthly and ORG subsample
create_extracts, begin("1985m1") end("1985m12")

* create documentation
*do ${codedocs}createdocs.do
