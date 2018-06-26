* Utility programs called by master.do



*************************************************************************
* NAME: append_extracts
* DESC: Append uniform extracts in extracts/ and load into memory.
* Useful for analysis/testing. Not used in the creation of extracts.
*************************************************************************
capture program drop append_extracts
program define append_extracts
syntax, begin(string) end(string) sample(string) [version(string)] [keeponly(string)]

local lowersample = lower("`sample'")

if "`lowersample'" == "org" local samplename ORG
else if "`lowersample'" == "basic" local samplename Basic
else {
	di "Must specify Basic or ORG sample"
	exit
}

local dataversion = lower("`version'")
if "`version'" == "" local dataversion "local"
if "`dataversion'" ~= "production" & "`dataversion'" ~= "local" {
	di "Version must be local or production"
	exit
}

if "`dataversion'" == "production" local inputpath /data/cps/`lowersample'/epiextracts/
else local inputpath ${extracts}

di "Using `dataversion' version of the extracts located in `inputpath'"

* deal with dates
local begindate = tm(`begin')
local enddate = tm(`end')
local minyear = year(dofm(`begindate'))
local maxyear = year(dofm(`enddate'))

* create list of months for each year to process
foreach date of numlist `begindate'(1)`enddate' {
  local year = year(dofm(`date'))
  local month = month(dofm(`date'))
  local monthlist`year' `monthlist`year'' `month'
}

foreach year of numlist `minyear'(1)`maxyear' {
	local counter = 0
	foreach month of numlist `monthlist`year'' {
		local counter = `counter' + 1
	}

	if `counter' == 12 {
		local inputfile epi_cps`lowersample'_`year'.dta
		unzipfile `inputpath'`inputfile'.zip, replace
		if "`keeponly'" ~= "" use year month minsamp orgwgt `keeponly' using `inputfile', clear
		else use `inputfile', clear
		tempfile annualdata`year'
		save `annualdata`year''
		erase `inputfile'
	}

	else {
		foreach month of numlist `monthlist`year'' {
			local inputfile epi_cps`lowersample'_`year'_`month'.dta
			unzipfile `inputpath'`inputfile'.zip, replace
			if "`keeponly'" ~= "" use year month minsamp orgwgt `keeponly' using `inputfile', clear
			else use `inputfile', clear
			tempfile monthlydata`month'
			save `monthlydata`month''
			erase `inputfile'
		}
		local counter = 0
		foreach month of numlist `monthlist`year'' {
			local counter = `counter' + 1
			if `counter' == 1 use `monthlydata`month'', clear
			else append using `monthlydata`month''
		}
		tempfile annualdata`year'
		save `annualdata`year''
	}

}

local counter = 0
foreach year of numlist `minyear'(1)`maxyear' {
	local counter = `counter' + 1
	if `counter' == 1 use `annualdata`year'', clear
	else append using `annualdata`year''
}





end

*************************************************************************
* NAME: valuelabel2csv
* DESC: converts value label definitions to csv file
* used in documentation making programs
*************************************************************************
capture program drop valuelabel2csv
program define valuelabel2csv
syntax using, [VARiable(varname) label(string) replace]

if "`variable'" != "" & "`label'" != "" {
	di "specify either varname() or valname(), but not both"
	exit
}

if "`variable'" != "" {
	local labelname: value label `variable'
}
else {
	local labelname `label'
}

local outputfile = subinstr("`2'",",","",1)

label save `labelname' using `outputfile', `replace'
mac li _all
!sed -i.bak "s/label define `labelname' //g" `outputfile'
!sed -i.bak "s/', modify//g" `outputfile'
!sed -i.bak 's/\`//g' `outputfile'
!sed -i.bak 's/ "/,"/' `outputfile'
erase `outputfile'.bak
type `outputfile'

end



*************************************************************************
* NAME: process_rawbasic
* DESC: Processes raw data from Unicon or Census and converts to Stata
* format.
* Called by master.do
*************************************************************************
capture program drop process_rawbasic
program define process_rawbasic
syntax, begin(string) end(string)

* numeric codes beginning and end dates
local begindate = tm(`begin')
local enddate = tm(`end')

* No data prior to 1973: otherwise exit with error
if `begindate' < tm(1973m1) {
  di "No data prior to 1973"
  exit
}

* Begin date must be lte end date: otherwise exit with error
if `begindate' > `enddate' {
  di "Begin date must be prior to end date"
  exit
}

* Process unicon extracts for all years before 1994
if `begindate' <= tm(1993m12) {
  if `enddate' <= tm(1993m12) local tempenddate = `endate'
  else local tempenddate = tm(1993m12)
  foreach date of numlist `begindate'/`tempenddate' {
    di "Unicon " %tm `date' " ... already converted to Stata"
  }
}

* Process Census data all years 1994-present
if `begindate' >= tm(1994m1) | `enddate' >= tm(1994m1) {
  if `begindate' >= tm(1994m1) local tempbegindate = `begindate'
  else local tempbegindate = tm(1994m1)
  foreach date of numlist `tempbegindate'/`enddate' {
    di "Census CPS " %tm `date' " ... converting to Stata"
		* Use process_censusbasic function to convert the data to Stata
    process_censusbasic, datenum(`date')
  }
}

end



*************************************************************************
* NAME: process_censusbasic
* DESC: Processes raw data from Unicon or Census and converts to Stata
* format. Relies on dictionaries and do-files from NBER:
* https://www.nber.org/data/cps_basic_progs.html
* Called by process_rawbasic
*************************************************************************
* use raw Census data and NBER dictionaries for 1994+
capture program drop process_censusbasic
program define process_censusbasic
syntax, datenum(string)

* deal with dates
local month = month(dofm(`datenum'))
local year = year(dofm(`datenum'))
local shortyear: di substr("`year'",3,.)
if `month' == 1 local monthname jan
if `month' == 2 local monthname feb
if `month' == 3 local monthname mar
if `month' == 4 local monthname apr
if `month' == 5 local monthname may
if `month' == 6 local monthname jun
if `month' == 7 local monthname jul
if `month' == 8 local monthname aug
if `month' == 9 local monthname sep
if `month' == 10 local monthname oct
if `month' == 11 local monthname nov
if `month' == 12 local monthname dec

di "Running process_censusbasic, `year'm`month'"

******************************************
*** NEED TO ADD CODE TO PROCESS REWEIGHTS
******************************************
* add it here, go month by month


* determine dictionary/NBER do-file to use
* January 2017 - present date
if  tm(2017m1) <= `datenum' & `datenum' <= tm(2018m5) local nberprogname cpsbjan2017
* January 2015 - December 2016
if  tm(2015m1) <= `datenum' & `datenum' <= tm(2016m12) local nberprogname cpsbjan2015
* April 2014 - December 2014
if  tm(2014m4) <= `datenum' & `datenum' <= tm(2014m12) local nberprogname cpsbapr2014
* January 2014 - March 2014
if  tm(2014m1) <= `datenum' & `datenum' <= tm(2014m3) local nberprogname cpsbjan2014
* January 2013 - December 2013
if  tm(2013m1) <= `datenum' & `datenum' <= tm(2013m12) local nberprogname cpsbjan13
* May 2012 - December 2012
if  tm(2012m5) <= `datenum' & `datenum' <= tm(2012m12) local nberprogname cpsbmay12
* January 2010 - April 2012
if  tm(2010m1) <= `datenum' & `datenum' <= tm(2012m4) local nberprogname cpsbjan10
* January 2009 - December 2009
if  tm(2009m1) <= `datenum' & `datenum' <= tm(2009m12) local nberprogname cpsbjan09
***** revised weights dec 2007? *****
* January 2007 - December 2008
if  tm(2007m1) <= `datenum' & `datenum' <= tm(2008m12) local nberprogname cpsbjan07
* August 2005 - December 2006
if  tm(2005m8) <= `datenum' & `datenum' <= tm(2006m12) local nberprogname cpsbaug05
* May 2004 - July 2005
if  tm(2004m5) <= `datenum' & `datenum' <= tm(2005m7) local nberprogname cpsbmay04
* January 2003 - April 2004
if  tm(2003m1) <= `datenum' & `datenum' <= tm(2004m4) local nberprogname cpsbjan03
* January 1998 - December 2002
if  tm(1998m1) <= `datenum' & `datenum' <= tm(2002m12) local nberprogname cpsbjan98
* September 1995 - December 1997
if  tm(1995m9) <= `datenum' & `datenum' <= tm(1997m12) local nberprogname cpsbsep95
* June 1995 - August 1995
if  tm(1995m6) <= `datenum' & `datenum' <= tm(1995m8) local nberprogname cpsbjun95
* April 1994 - May 1995
if  tm(1994m4) <= `datenum' & `datenum' <= tm(1995m5) local nberprogname cpsbapr94
* January 1994 - March 1994
if  tm(1994m1) <= `datenum' & `datenum' <= tm(1994m3) local nberprogname cpsbjan94

* determine raw data to use
ashell zipinfo -1 "${censusbasicraw}`monthname'`shortyear'pub.zip"
local inputfilename: di r(o1)
* decompress raw data into current dir
unzipfile ${censusbasicraw}`monthname'`shortyear'pub.zip, replace
* use appropriate NBER .do/.dct
* arguments refer to dat_name (`1') and dct_name (`2') in NBER do files
* before running, make necessary changes NBER do files to accept arguments
clear
do ${dictionaries}`nberprogname'.do `inputfilename' ${dictionaries}`nberprogname'.dct

* include code here for certain months to add reweights

* save, compress, clean up
compress
save cps_`year'_`month'.dta, replace
zipfile cps_`year'_`month'.dta, saving(cps_`year'_`month'.dta.zip, replace)
copy cps_`year'_`month'.dta.zip ${censusbasicstata}cps_`year'_`month'.dta.zip, replace
erase cps_`year'_`month'.dta
erase cps_`year'_`month'.dta.zip
erase `inputfilename'

end



*************************************************************************
* NAME: create_extracts
* DESC: Create uniform EPI extracts of CPS basic monthlies and May/ORG
* Called by master.do
*************************************************************************
capture program drop create_extracts
program define create_extracts
syntax, begin(string) end(string) [keeponly(string)]

* preliminary data
import delimited using ${suppdata}state_geocodes.csv, clear varnames(1)
labmask statefips, val(stateabb)
labmask statecensus, val(stateabb)
labmask division, val(divisionname)
labmask region, val(regionname)
drop *name
* start ridiculous hack to add value labels for these variables
* after merging them later in epi_cpsbasic_geog.do
foreach var of varlist statefips statecensus {
	gen `var'_alt = `var'
	lab val `var'_alt `var'
}
keep statefips* statecensus* division* region*
tempfile stategeocodes
save `stategeocodes'

* cpi

* deal with dates
local begindate = tm(`begin')
local enddate = tm(`end')
local minyear = year(dofm(`begindate'))
local maxyear = year(dofm(`enddate'))

* create list of months for each year to process
foreach date of numlist `begindate'(1)`enddate' {
  local year = year(dofm(`date'))
  local month = month(dofm(`date'))
  local monthlist`year' `monthlist`year'' `month'
}

* process all data
foreach year of numlist `minyear'(1)`maxyear' {

/*
	* first process annual may if necessary
	if `year' < 1979 {
		* unzip may
		* use may
		* run programs
		* save data
		compress
		notes drop _dta
		label data "EPI CPS May Extract, Version $dataversion"
		saveold ${extracts}epi_cpsmay_`year'.dta, replace version(13)
		zipfile epi_cpsmayc_`year'.dta, saving(epi_cpsmay_`year'.dta.zip, replace)
		copy epi_cpsmay_`year'.dta.zip ${extracts}epi_cpsmay_`year'.dta.zip, replace
		erase epi_cpsmay_`year'.dta
		erase epi_cpsmay_`year'.dta.zip

	}
*/

	* 1976 and later, process monthly basic and possibly monthly ORG
	if `year' >= 1976 {
		* start a counter to help determine if we have a full year of data
		local counter = 0
		foreach month of numlist `monthlist`year'' {
			local counter = `counter' + 1
      * define current month
      local date = tm(`year'm`month')
			* indicator for existence of ORG files
      if `date' >= tm(1979m1) local orgexists = 1
      else local orgexists = 0
      * indicator for ORG files being separate from basic files
			if tm(1979m1) <= `date' & `date' <= tm(1981m12) local separateorg = 1
			else local separateorg = 0

			* file names of basic source data in stata format
			if tm(1976m1) <= `date' & `date' <= tm(1993m12) {
				local inputpath ${uniconbasic}
				local inputfile unicon_basic_`year'_`month'.dta
			}
			if tm(1994m1) <= `date' {
				local inputpath ${censusbasicstata}
				local inputfile cps_`year'_`month'.dta
			}
      * unzip and load source data into memory
			unzipfile `inputpath'`inputfile'.zip, replace
			use `inputfile', clear

			* indicator if file contains earner info
			if `date' >= tm(1982m1) local earnerinfo = 1
			else local earnerinfo = 0

			* run key basic/org programs
			do ${code}epi_cpsbasic_sample.do `date'
			do ${code}epi_cpsbasic_idwgt.do `date'
			do ${code}epi_cpsbasic_geog.do `date' `stategeocodes'
			do ${code}epi_cpsbasic_demog.do `date'
			do ${code}epi_cpsbasic_empstat.do `date'
			do ${code}epi_cpsorg_wages.do `date' `earnerinfo'
			do ${code}epi_cpsbasic_keepord.do `date'

      * limit sample to certain variables for debugging
      if "`keeponly'" ~= "" keep year month minsamp orgwgt `keeponly'

			* save basic monthly extract
			tempfile basic_month`month'
			save `basic_month`month''

			* save separate org subsample
      if `orgexists' == 1 & `separateorg' == 0 {
				* keep org subsample
				do ${code}epi_cpsorg_sample.do `date'

        * limit sample to certain variables for debugging
        if "`keeponly'" ~= "" keep year month minsamp orgwgt `keeponly'

        tempfile org_month`month'
        save `org_month`month''
      }

			* clean up basic monthly input file
			erase `inputfile'

			* process separate 1979-1981 ORG
			if `orgexists' == 1 & `separateorg' == 1 {
				* file names of ORG source data in stata format
				local inputpath ${uniconorg}
				local inputfile unicon_org_`year'_`month'.dta

				unzipfile `inputpath'`inputfile'.zip, replace
				use `inputfile', clear

				* indicator if file contains earner info
				local earnerinfo = 1

				* run key basic/org programs
				do ${code}epi_cpsbasic_sample.do `date'
				do ${code}epi_cpsbasic_idwgt.do `date'
				do ${code}epi_cpsbasic_geog.do `date' `stategeocodes'
				do ${code}epi_cpsbasic_demog.do `date'
				do ${code}epi_cpsbasic_empstat.do `date'
				do ${code}epi_cpsorg_wages.do `date' `earnerinfo'
				do ${code}epi_cpsbasic_keepord.do `date'

				* keep org subsample
				do ${code}epi_cpsorg_sample.do `date'

				* limit sample to certain variables for debugging
				if "`keeponly'" ~= "" keep year month minsamp orgwgt `keeponly'

				* save basic monthly extract
				tempfile org_month`month'
				save `org_month`month''

				erase `inputfile'
			}
		}

		* if complete year, combine all months into one year dataset
		if `counter' == 12 {
			* Basic monthly
			forvalues month = 1 / 12 {
				if `month' == 1 use `basic_month`month'', clear
				else append using `basic_month`month''
			}
			compress
			notes drop _dta
			label data "EPI CPS Basic Monthly Extract, Version $dataversion"
			saveold epi_cpsbasic_`year'.dta, replace version(13)
			zipfile epi_cpsbasic_`year'.dta, saving(epi_cpsbasic_`year'.dta.zip, replace)
			copy epi_cpsbasic_`year'.dta.zip ${extracts}epi_cpsbasic_`year'.dta.zip, replace
			erase epi_cpsbasic_`year'.dta
			erase epi_cpsbasic_`year'.dta.zip

			* ORG, if exists
			if `orgexists' == 1 {
				forvalues month = 1 / 12 {
					if `month' == 1 use `org_month`month'', clear
					else append using `org_month`month''
				}
				compress
				notes drop _dta
				label data "EPI CPS ORG Extract, Version $dataversion"
				saveold epi_cpsorg_`year'.dta, replace version(13)
				zipfile epi_cpsorg_`year'.dta, saving(epi_cpsorg_`year'.dta.zip, replace)
				copy epi_cpsorg_`year'.dta.zip ${extracts}epi_cpsorg_`year'.dta.zip, replace
				erase epi_cpsorg_`year'.dta
				erase epi_cpsorg_`year'.dta.zip
			}
		}
		* otherwise save individual months
		else {
			foreach month of numlist `monthlist`year'' {
				use `basic_month`month'', clear
				compress
				notes drop _dta
				label data "EPI CPS Basic Monthly Extract, Version $dataversion"
				saveold epi_cpsbasic_`year'_`month'.dta, replace version(13)
				zipfile epi_cpsbasic_`year'_`month'.dta, saving(epi_cpsbasic_`year'_`month'.dta.zip, replace)
				copy epi_cpsbasic_`year'_`month'.dta.zip ${extracts}epi_cpsbasic_`year'_`month'.dta.zip, replace
				erase epi_cpsbasic_`year'_`month'.dta
				erase epi_cpsbasic_`year'_`month'.dta.zip

				* ORG, if exists
				if `orgexists' == 1 {
					use `org_month`month'', clear
					compress
					notes drop _dta
					label data "EPI CPS ORG Extract, Version $dataversion"
					saveold epi_cpsorg_`year'_`month'.dta, replace version(13)
					zipfile epi_cpsorg_`year'_`month'.dta, saving(epi_cpsorg_`year'_`month'.dta.zip, replace)
					copy epi_cpsorg_`year'_`month'.dta.zip ${extracts}epi_cpsorg_`year'_`month'.dta.zip, replace
					erase epi_cpsorg_`year'_`month'.dta
					erase epi_cpsorg_`year'_`month'.dta.zip
				}


			}
		}


	}
}


end
