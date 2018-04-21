* FILE: master.do
* DESC: master do-file to create EPI CPS Basic and ORG extracts
clear all
set more off

* project directory structure
* set your stata working directory to the project root containing master.do
global dofiles code/
global extracts extracts/
global suppdata suppdata/

* CPS raw data directories
global uniconbasic /data/cps/basic/unicon/
global censusbasic /data/cps/basic/census/
global uniconorg /data/cps/org/unicon/

* load key programs
do ${dofiles}utilities.do

* process the raw data
processrawdata, begin() end()
