* Utility programs called by master.do


* program to keep variables if they exist
capture program drop keepifexist
program define keepifexist, rclass
syntax anything
local keeplist ""
foreach x in `anything' {
        capture unab y: `x'
        if _rc == 0 {
                foreach z of varlist `y' {
                        local keeplist `keeplist' `z'
                }
        }
        else local keeplist `keeplist'
}

if "`keeplist'" == "" {
	noi di "Warning: none of those variables existed. All variables dropped."
	error 1
}
else {
        di "Keeping `keeplist'"
        keep `keeplist'
}
return local keeplist "`keeplist'"
end


capture program drop append_rawdata
program define append_rawdata
syntax, begin(integer) end(integer) sample(string) [keeponly(string)]

* determine sample
local lowersample = lower("`sample'")
if "`lowersample'" == "org" local samplename ORG
else if "`lowersample'" == "basic" local samplename Basic
else if "`lowersample'" == "may" local samplename May
else {
	di _n "You must specify Basic or ORG or May sample."
	error 1
}
di _n "Working on CPS `samplename' from `begin' to `end'..."

foreach year of numlist `begin'(1)`end' {
	* file paths
	if "`lowersample'" == "may" {
		local inputpath /data/cps/may/unicon/
	}
	else if "`lowersample'" == "org" & `year' >= 1979 & `year' <= 1983 {
		local inputpath /data/cps/org/unicon/
	}
	else if "`lowersample'" == "org" & `year' >= 1984 & `year' <= 1993 {
		local inputpath /data/cps/basic/unicon/
	}
	else if "`lowersample'" == "basic" & `year' <= 1993 {
		local inputpath /data/cps/basic/unicon/
	}
	else if ("`lowersample'" == "basic" | "`lowersample'" == "org") & `year' >= 1994 {
		local inputpath /data/cps/basic/census/stata/
	}
	else {
		di "Sample and years combination not valid"
		error 1
	}

	* determine whether annual or monthly sample
	if "`lowersample'" == "may" local annualsample = 1
	else local annualsample = 0

	* create keep statement for ORG subsamples
	if "`lowersample'" == "org" {
		if `year' >= 1979 & `year' <= 1993 local keeponlyorg keep if (mis == 4 | mis == 8) & ernwgt > 0 & ernwgt ~= .
		if `year' >= 1994 local keeponlyorg keep if (hrmis == 4 | hrmis == 8) & pworwgt > 0 & pworwgt ~= .
	}
	else local keeponlyorg ""

	* Load each annual file
	if `annualsample' == 1 {
		if "`lowersample'" == "may" local inputfile unicon_may_`year'.dta
		else {
			di "Something is wrong with your intended sample"
			error 1
		}
		qui {
			unzipfile `inputpath'`inputfile'.zip, replace
			use `inputfile', clear
			if "`keeponly'" ~= "" {
				keepifexist `keeponly'
				local keeplist "`r(keeplist)'"
			}
			else local keeplist "_all"
			cap drop year
			gen int year = `year'
			noi di "Loading CPS `samplename', `year': `keeplist'"
			tempfile annualdata`year'
			save `annualdata`year''
			erase `inputfile'
		}

	}

	* Local each monthly file and create annual file
	if `annualsample' == 0 {
		forvalues month = 1/12 {
			if "`lowersample'" == "org" & `year' <= 1983 {
				local inputfile unicon_org_`year'_`month'.dta
			}
			else if ("`lowersample'" == "basic" | "`lowersample'" == "org") & `year' <= 1993 {
				local inputfile unicon_basic_`year'_`month'.dta
			}
			else if ("`lowersample'" == "basic" | "`lowersample'" == "org") & `year' >= 1994 {
				local inputfile cps_`year'_`month'.dta
			}
			qui {
				unzipfile `inputpath'`inputfile'.zip, replace
				use `inputfile', clear
				if "`lowersample'" == "org" {
					`keeponlyorg'
				}
				if "`keeponly'" ~= "" {
					keepifexist `keeponly'
					local keeplist "`r(keeplist)'"
				}
				else local keeplist "_all"
				cap drop month
				gen int month = `month'
				noi di "Loading CPS `samplename', `year'-`month': `keeplist'"
				tempfile monthlydata`month'
				save `monthlydata`month''
				erase `inputfile'
			}
		}
		qui {
			forvalues month = 1/12 {
				if `month' == 1 use `monthlydata`month'', clear
				else append using `monthlydata`month'', force
			}
			cap drop year
			gen int year = `year'
			tempfile annualdata`year'
			save `annualdata`year''
		}
	}
}

* append years of data together
qui foreach year of numlist `begin'(1)`end' {
	local counter = `counter' + 1
	if `counter' == 1 use `annualdata`year'', clear
	else append using `annualdata`year'', force
}

end

*************************************************************************
* NAME: append_extracts
* DESC: Append uniform extracts in extracts/ and load into memory.
* Useful for analysis/testing. Not used in the creation of extracts.
*************************************************************************
capture program drop append_extracts
program define append_extracts
syntax, begin(string) end(string) sample(string) [version(string)] [keeponly(string)]

* determine sample
local lowersample = lower("`sample'")
if "`lowersample'" == "org" local samplename ORG
else if "`lowersample'" == "basic" local samplename Basic
else if "`lowersample'" == "swa" local samplename SWA
else if "`lowersample'" == "may" local samplename May
else {
	di _n "You must specify Basic or ORG or SWA or May sample."
	error 1
}

* determine version
local dataversion = lower("`version'")
if "`version'" == "" local dataversion "local"
if "`dataversion'" ~= "production" & "`dataversion'" ~= "local" & "`dataversion'" ~= "old" {
	di _n "Version must be local, production, or old."
	error 1
}
if ("`dataversion'" == "production" | "`dataversion'" == "local") & "`lowersample'" == "swa" {
	di _n "Only the old version of the SWA extracts exists."
	error 1
}

* determine path of version and sample
if "`dataversion'" == "production" local inputpath /data/cps/`lowersample'/epiextracts/
if "`dataversion'" == "old" & ("`lowersample'" == "org" | "`lowersample'" == "swa" | "`lowersample'" == "may") local inputpath /data/cps/org/epi/stata/
if "`dataversion'" == "old" & "`lowersample'" == "basic" local inputpath /data/cps/basic/epi/stata/
if "`dataversion'" == "local" local inputpath ${extracts}

di _n "Using `dataversion' version of the CPS `samplename' extracts located in `inputpath'" _n

* deal with dates
local begindate = tm(`begin')
local enddate = tm(`end')
local minyear = year(dofm(`begindate'))
local maxyear = year(dofm(`enddate'))
local minmonth = month(dofm(`begindate'))
local maxmonth = month(dofm(`enddate'))
* quarterdate list for EPI Basic
local minquarterdate = yq(`minyear',quarter(dofm(`begindate')))
local maxquarterdate = yq(`maxyear',quarter(dofm(`enddate')))

* min month and max month check for old Basic
if "`dataversion'" == "old" & "`lowersample'" == "basic" {
	local invalidmonth = 0
	if inlist(`minmonth',1,4,7,10) ~= 1 {
		local invalidmonth = 1
		di "Beginning month invalid."
	}
	if inlist(`maxmonth',3,6,9,12) ~= 1 {
		local invalidmonth = 1
		di "Ending month invalid."
	}
	if `invalidmonth' == 1 {
		di _n "Mid-quarter samples are not available for the old EPI Basic, which is available quarterly."
		di "For this dataset, select a month range comprising full quarters -- e.g., begin(2012m4) end(2015m9)."
		error 1
	}
}

* min month and max month check for old ORG/May
if "`dataversion'" == "old" & ("`lowersample'" == "org" | "`lowersample'" == "swa" | "`lowersample'" == "may") {
	local invalidmonth = 0
	if `minmonth' ~= 1 {
		local invalidmonth = 1
		di "Beginning month invalid."
	}
	if `maxmonth' ~= 12 {
		local invalidmonth = 1
		di "Ending month invalid."
	}
	if `invalidmonth' == 1 {
		di _n "Mid-year samples are not available for the old EPI SWA/ORG/May samples, which are available annually"
		di "For these datasets, select month ranges comprising full years -- e.g., begin(2012m1) end(2015m12)"
		error 1
	}
}

* create list of months for each year to process
foreach date of numlist `begindate'(1)`enddate' {
  local year = year(dofm(`date'))
  local month = month(dofm(`date'))
  local monthlist`year' `monthlist`year'' `month'
}

* keeponly varlists for datasets
if "`keeponly'" ~= "" {
	if "`dataversion'" == "old" & ("`lowersample'" == "org" | "`lowersample'" == "swa") {
		local keeponlylist `keeponly' month mins orgwt
	}
	if "`dataversion'" == "old" & "`lowersample'" == "basic" {
		local keeponlylist `keeponly' month mins *wgt*
	}
	if "`dataversion'" == "old" & "`lowersample'" == "may" {
		local keeponlylist `keeponly' month finalwt
	}
	if "`dataversion'" == "production" | "`dataversion'" == "local" {
		local keeponlylist `keeponly' year month mins *wgt*
	}
}

* process old EPI Basic (quarterly)
if "`dataversion'" == "old" & "`lowersample'" == "basic" {
	foreach quarterdate of numlist `minquarterdate'(1)`maxquarterdate' {
		local year = year(dofq(`quarterdate'))
		local shortyear = substr("`year'",3,2)
		local quarter = quarter(dofq(`quarterdate'))
		local inputfile cps`shortyear'q`quarter'.dta
		unzipfile `inputpath'`inputfile'.zip, replace
		use `keeponlylist' using `inputfile', clear
		gen year = `year'
		tempfile quarterlydata`quarterdate'
		save `quarterlydata`quarterdate''
		erase `inputfile'
	}
	local counter = 0
	foreach quarterdate of numlist `minquarterdate'(1)`maxquarterdate' {
		local counter = `counter' + 1
		if `counter' == 1 use `quarterlydata`quarterdate'', clear
		else append using `quarterlydata`quarterdate''
	}
}
* process all other datasets (annual, or monthly)
else {
	foreach year of numlist `minyear'(1)`maxyear' {
		local counter = 0
		foreach month of numlist `monthlist`year'' {
			local counter = `counter' + 1
		}
		if `counter' == 12 {
			if "`dataversion'" == "local" | "`dataversion'" == "production" local inputfile epi_cps`lowersample'_`year'.dta
			local shortyear = substr("`year'",3,2)
			if "`dataversion'" == "old" & "`lowersample'" == "org" {
				local inputfile org`shortyear'c.dta
			}
			if "`dataversion'" == "old" & "`lowersample'" == "swa" {
				local inputfile wage`shortyear'c.dta
			}
			if "`dataversion'" == "old" & "`lowersample'" == "may" {
				local inputfile may`shortyear'c.dta
			}
			unzipfile `inputpath'`inputfile'.zip, replace
			use `keeponlylist' using `inputfile', clear
			if "`dataversion'" == "old" gen year = `year'
			tempfile annualdata`year'
			save `annualdata`year''
			erase `inputfile'
		}
		* monthly files will be either production or local
		else {
			foreach month of numlist `monthlist`year'' {
				local inputfile epi_cps`lowersample'_`year'_`month'.dta
				unzipfile `inputpath'`inputfile'.zip, replace
				use `keeponlylist' using `inputfile', clear
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

if `begindate' < tm(1973m1) {
	di _n "Data is not available for" %tm `begindate'
	error 1
}

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



* process all data
foreach year of numlist `minyear'(1)`maxyear' {
	* reset survey sample settings
	global monthlycps = 0
	global maycps = 0
	global earnerinfo = 0

	* first process annual may if necessary
	if 1973 <= `year' & `year' <= 1981 {
		* survey sample settings
		global monthlycps = 0
		global maycps = 1
		global earnerinfo = 1
		global basicfile = 0

		* for May CPS, use month=5 (may)
		local date = tm(`year'm5)

		* input files
		local inputpath ${uniconmay}
		local inputfile unicon_may_`year'.dta

		* load data
		unzipfile `inputpath'`inputfile'.zip, replace
		use `inputfile', clear

		* run key basic/org programs
		do ${code}epi_cpsbasic_sample.do `date'
		do ${code}epi_cpsbasic_idwgt.do `date'
		do ${code}epi_cpsbasic_geog.do `date' `stategeocodes'
		do ${code}epi_cpsbasic_demog.do `date'
		do ${code}epi_cpsbasic_empstat.do `date'
		do ${code}epi_cpsorg_wages.do `date'
		do ${code}epi_cpsbasic_keepord.do `date'

		* clean up
		erase `inputfile'

		* save data
		compress
		notes drop _dta
		notes _dta: EPI CPS May Extract, Version $dataversion
		label data "EPI CPS May Extract, Version $dataversion"
		saveold epi_cpsmay_`year'.dta, replace version(13)
		zipfile epi_cpsmay_`year'.dta, saving(epi_cpsmay_`year'.dta.zip, replace)
		copy epi_cpsmay_`year'.dta.zip ${extracts}epi_cpsmay_`year'.dta.zip, replace
		erase epi_cpsmay_`year'.dta
		erase epi_cpsmay_`year'.dta.zip
	}


	* 1976 and later, process monthly basic and possibly monthly ORG
	if `year' >= 1976 {
		global monthlycps = 1
		global maycps = 0
		global earnerinfo = 0
		global basicfile = 0

		* start a counter to help determine if we have a full year of data
		local counter = 0
		foreach month of numlist `monthlist`year'' {
			local counter = `counter' + 1

      * define current month
      local date = tm(`year'm`month')

      * indicator for using basic monthly file
      global basicfile = 1

			* indicator for existence of ORG files
      if `date' >= tm(1979m1) local orgexists = 1
      else local orgexists = 0

      * indicator for ORG files being separate from basic files
			if tm(1979m1) <= `date' & `date' <= tm(1983m12) local separateorg = 1
			else local separateorg = 0

			* indicator if file contains earner info
			if `date' >= tm(1982m1) global earnerinfo = 1
			else global earnerinfo = 0

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

			* run key basic/org programs
			do ${code}epi_cpsbasic_sample.do `date'
			do ${code}epi_cpsbasic_idwgt.do `date'
			do ${code}epi_cpsbasic_geog.do `date' `stategeocodes'
			do ${code}epi_cpsbasic_demog.do `date'
			do ${code}epi_cpsbasic_empstat.do `date'
			do ${code}epi_cpsorg_wages.do `date'
			do ${code}epi_cpsbasic_keepord.do `date'

      * limit sample to certain variables for debugging
      if "`keeponly'" ~= "" keep year month minsamp basicwgt orgwgt `keeponly'

			* save basic monthly extract
			tempfile basic_month`month'
			save `basic_month`month''

			* save separate org subsample
      if `orgexists' == 1 & `separateorg' == 0 {
				* keep org subsample
				do ${code}epi_cpsorg_sample.do `date'

        * limit sample to certain variables for debugging
        if "`keeponly'" ~= "" keep year month minsamp basicwgt orgwgt `keeponly'

        tempfile org_month`month'
        save `org_month`month''
      }

			* clean up basic monthly input file
			erase `inputfile'

			* process separate 1979-1981 ORG
			if `orgexists' == 1 & `separateorg' == 1 {
				* indicator for using basic monthly file
				global basicfile = 0

				* indicator if file contains earner info
				global earnerinfo = 1

				* file names of ORG source data in stata format
				local inputpath ${uniconorg}
				local inputfile unicon_org_`year'_`month'.dta

				unzipfile `inputpath'`inputfile'.zip, replace
				use `inputfile', clear

				* run key basic/org programs
				do ${code}epi_cpsbasic_sample.do `date'
				do ${code}epi_cpsbasic_idwgt.do `date'
				do ${code}epi_cpsbasic_geog.do `date' `stategeocodes'
				do ${code}epi_cpsbasic_demog.do `date'
				do ${code}epi_cpsbasic_empstat.do `date'
				do ${code}epi_cpsorg_wages.do `date'
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

			* right here is probably where we should handle earnings & hours imputations
      global basicfile = 1
      do ${code}epi_cpsorg_topcode.do `year'
      do ${code}epi_cpsorg_realwage.do `year'

			notes drop _dta
			notes _dta: EPI CPS Basic Monthly Extract, Version $dataversion
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

        * right here is probably where we should handle earnings & hours imputations
        global basicfile = 0
        do ${code}epi_cpsorg_topcode.do `date'
        do ${code}epi_cpsorg_realwage.do `date'

				notes drop _dta
				notes _dta: EPI CPS ORG Extract, Version $dataversion
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
				notes _dta: EPI CPS Basic Monthly Extract, Version $dataversion
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
					notes _dta: EPI CPS ORG Extract, Version $dataversion
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
