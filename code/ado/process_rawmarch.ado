*************************************************************************
* NAME: process_rawmarch
* DESC: Processes raw March data from Unicon or Census and converts to Stata
* format.
* Called by master.do
*************************************************************************
capture program drop process_rawmarch
program define process_rawmarch
syntax, begin(integer) end(integer)

* numeric codes beginning and end dates
local begindate = `begin'
local enddate = `end'

* No data prior to 1973: otherwise exit with error
if `begindate' < 1962 {
  di "No data prior to 1962"
  exit
}

* Begin date must be lte end date: otherwise exit with error
if `begindate' > `enddate' {
  di "Begin date must be prior to end date"
  exit
}

* Process unicon extracts for all years before 2013
if `begindate' <= 2012 {
  if `enddate' <= 2012 local tempenddate = `endate'
  else local tempenddate = 2012
  foreach year of numlist `begindate'/`tempenddate' {
    di "Unicon " `year' " ... already converted to Stata"
  }
}

* Process Census data all years 2013-present
if `begindate' >= 2013 | `enddate' >= 2013 {
  if `begindate' >= 2013 local tempbegindate = `begindate'
  else local tempbegindate = 2013
  foreach year of numlist `tempbegindate'/`enddate' {
    di "Census CPS " `year' " ... converting to Stata"
		* Use process_censusbasic function to convert the data to Stata
    process_censusmarch, year(`year')
  }
}

end



*************************************************************************
* NAME: process_censusmarch
* DESC: Processes raw March data from Census and converts to Stata
* format. Relies on dictionaries and do-files from NBER:
* https://www.nber.org/data/cps_progs.html
* Called by process_rawmarch
*************************************************************************
capture program drop process_censusmarch
program define process_censusmarch
syntax, year(integer)

local shortyear = substr("`year'",3,2)

* determine dictionary/NBER do-file to use
if 2013 <= `year' & `year' <= 2018 {
	local nberprogname cpsmar`year'
}
* determine archive name
if `year' == 2013 local archivename asec2013_pubuse.zip
if `year' == 2014 local archivename asec2014_pubuse_3x8_rerun_v2.zip
if `year' == 2015 local archivename asec2015_pubuse.zip
if `year' == 2016 local archivename asec2016_pubuse_v3.zip
if `year' == 2017 local archivename asec2017_pubuse.zip
if `year' == 2018 local archivename asec2018_pubuse.zip

tempfile rawdat
!unzip -p ${censusmarchraw}`archivename' > `rawdat'

* use appropriate NBER .do/.dct
* arguments refer to dat_name (`1') and dct_name (`2') in NBER do files
* before running, make necessary changes NBER do files to accept arguments
clear
do ${dictionaries}`nberprogname'.do `rawdat' ${dictionaries}`nberprogname'.dct

* save, compress, clean up
compress
save cpsmarch_`year'.dta, replace
zipfile cpsmarch_`year'.dta, saving(cpsmarch_`year'.dta.zip, replace)
copy cpsmarch_`year'.dta.zip ${censusmarchstata}cpsmarch_`year'.dta.zip, replace
erase cpsmarch_`year'.dta
erase cpsmarch_`year'.dta.zip

* run traditional file as well
if `year' == 2014 {
	local nberprogname cpsmar2014t
	local archivename asec2014_pubuse_tax_fix_5x8_2017.zip

	tempfile rawdat
	!unzip -p ${censusmarchraw}`archivename' > `rawdat'

	clear
	do ${dictionaries}`nberprogname'.do `rawdat' ${dictionaries}`nberprogname'.dct

	* save, compress, clean up
	compress
	save cpsmarch_`year'_traditional.dta, replace
	zipfile cpsmarch_`year'_traditional.dta, saving(cpsmarch_`year'_traditional.dta.zip, replace)
	copy cpsmarch_`year'_traditional.dta.zip ${censusmarchstata}cpsmarch_`year'_traditional.dta.zip, replace
	erase cpsmarch_`year'_traditional.dta
	erase cpsmarch_`year'_traditional.dta.zip
}

end
