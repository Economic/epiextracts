*************************************************************************
* NAME: append_extracts
* DESC: Append uniform extracts in extracts/ and load into memory.
* Useful for analysis/testing. Used in documentation creation.
* Not used in the creation of extracts.
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
if "`version'" == "" local dataversion "production"
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

		qui {
			unzipfile `inputpath'`inputfile'.zip, replace
			use `inputfile', clear
			if "`keeponly'" ~= "" {
				keepifexist `keeponlylist'
				local keeplist "`r(keeplist)'"
			}
			else local keeplist "_all"
			gen int year = `year'
			noi di "Processing `dataversion' CPS `samplename', " %tq `quarterdate' ": `keeplist'"
			tempfile quarterlydata`quarterdate'
			save `quarterlydata`quarterdate''
			erase `inputfile'
		}
	}
	local counter = 0
	qui foreach quarterdate of numlist `minquarterdate'(1)`maxquarterdate' {
		local counter = `counter' + 1
		noi di "Loading `dataversion' CPS `samplename', " %tq `quarterdate'
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

			qui {
				unzipfile `inputpath'`inputfile'.zip, replace
				use `inputfile', clear
				if "`keeponly'" ~= "" {
					keepifexist `keeponlylist'
					local keeplist "`r(keeplist)'"
				}
				else local keeplist "_all"
				if "`dataversion'" == "old" gen int year = `year'
				noi di "Processing `dataversion' CPS `samplename', `year': `keeplist'"
				tempfile annualdata`year'
				save `annualdata`year''
				erase `inputfile'
			}
		}
		* monthly files will be either production or local
		else {
			* determine whether annual files exist
			capture confirm file `inputpath'epi_cps`lowersample'_`year'.dta.zip
			* if annual exists, use appropriate months from that file
			if _rc == 0 {
				local inputfile epi_cps`lowersample'_`year'.dta
				qui {
					unzipfile `inputpath'`inputfile'.zip, replace
					foreach month of numlist `monthlist`year'' {
						use if month == `month' using `inputfile', clear
						if "`keeponly'" ~= "" {
							keepifexist `keeponlylist'
							local keeplist "`r(keeplist)'"
						}
						else local keeplist "_all"
						noi di "Processing `dataversion' CPS `samplename', `year'm`month': `keeplist'"
						tempfile monthlydata`month'
						save `monthlydata`month''
					}
				}
				erase `inputfile'
			}
			* if annual does not exist, try monthly files
			else {
				foreach month of numlist `monthlist`year'' {
					local inputfile epi_cps`lowersample'_`year'_`month'.dta
					qui {
						unzipfile `inputpath'`inputfile'.zip, replace
						use `inputfile', clear
						if "`keeponly'" ~= "" {
							keepifexist `keeponlylist'
							local keeplist "`r(keeplist)'"
						}
						else local keeplist "_all"
						noi di "Processing `dataversion' CPS `samplename', `year'm`month': `keeplist'"
						tempfile monthlydata`month'
						save `monthlydata`month''
						erase `inputfile'
					}
				}
			}
			* combine monthly files into annual file
			local counter = 0
			qui {
				foreach month of numlist `monthlist`year'' {
					local counter = `counter' + 1
					if `counter' == 1 use `monthlydata`month'', clear
					else append using `monthlydata`month''
				}
				tempfile annualdata`year'
				save `annualdata`year''
			}
		}
	}
	* combine all files
	local counter = 0
	qui foreach year of numlist `minyear'(1)`maxyear' {
		local counter = `counter' + 1
		noi di "Loading `dataversion' CPS `samplename', `year'"
		if `counter' == 1 use `annualdata`year'', clear
		else append using `annualdata`year''
	}
}

end
