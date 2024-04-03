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
* 
* you also need the python module tabulate: https://pypi.org/project/tabulate/

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
global dataversion 1.0


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

*create_extracts, begin(2024m1) end(2024m2)

local year 2022

  if 2019 <=`year' & `year' <= 2023 {
    local archivename asecpub`year'csv.zip
    local filename asec_csv_repwgt_`year'.csv
  }

	!unzip ${censusmarchraw}`archivename' -d ${censusmarchraw}tempfolder

  *note: 2019 zipped data has more complicated zipped folder structure
  if `year' == 2019 {
    import delimited "${censusmarchraw}tempfolder/cpsb/asec/prod/data/2019/`filename'"
  }
  else {
    import delimited "${censusmarchraw}tempfolder/`filename'"
  }

  * save, compress, clean up
  compress
  saveold cpsmarch_`year'.dta, replace version(13)
  zipfile cpsmarch_`year'.dta, saving(cpsmarch_`year'.dta.zip, replace)
  copy cpsmarch_`year'.dta.zip ${censusmarchstata}cpsmarch_`year'.dta.zip, replace
  erase cpsmarch_`year'.dta
  erase cpsmarch_`year'.dta.zip
  

* process_rawmarch, begin(2022) end(2022)
*process_rawbasic, begin(2023m11) end(2024m1)

* create EPI's extracts from the processed raw data
* creates both basic monthly and ORG subsample
*create_extracts, begin(2023m1) end(2024m1)

* create documentation
* do ${codedocs}createdocs.do
