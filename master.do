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

* CPS raw data directories
global uniconbasic /data/cps/basic/unicon/
global censusbasic /data/cps/basic/census/
global uniconorg /data/cps/org/unicon/

* load key programs
do ${code}utilities.do

* process the raw data and convert it to Stata format
* this is only necessary for additional months of data
processrawbasic, begin("1976m1") end("2017m12")
