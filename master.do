* FILE: master.do
* DESC: master do-file to create EPI CPS Basic and ORG extracts
clear all
set more off
set trace off

* project directory structure
* set your stata working directory to the project root containing master.do
global code code/
global extracts extracts/
global suppdata suppdata/
global codedocs ${code}docs/

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

global ceprdata /data/cps/org/cepr/

* path names for docs
global docs docs/
global variabledocs ${docs}variables/
global variabledesc ${docs}variables/descriptions/
global variableanalysis ${docs}variables/analysis/

* process the raw data and convert it to Stata format
* this is only necessary for additional months of data
*process_rawbasic, begin("1976m1") end("2017m12")

* create EPI's extracts from the processed raw data
* creates both basic monthly and ORG subsample
*create_extracts, begin("1976m1") end("2017m12")

* create documentation
do ${codedocs}createdocs.do
