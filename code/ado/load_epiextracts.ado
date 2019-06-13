*************************************************************************
* NAME: load_epiextracts
* DESC: Append uniform extracts in extracts/ and load into memory.
* Useful for analysis/testing. Used in documentation creation.
* Not used in the creation of extracts.
*************************************************************************
capture program drop load_epiextracts
program define load_epiextracts
syntax, begin(string) end(string) sample(string) [keep(string) version(string) sourcedir(string)]

* determine sample
local lowersample = lower("`sample'")
if "`lowersample'" == "org" local samplename ORG
else if "`lowersample'" == "basic" local samplename Basic
else if "`lowersample'" == "swa" local samplename SWA
else if "`lowersample'" == "may" local samplename May
else if "`lowersample'" == "march" local samplename March
else {
	di _n "You must specify Basic or March or May or ORG sample."
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
	di _n "Only the old version of the EPI SWA extracts exists."
	error 1
}

* determine input path of version and sample
if "`sourcedir'" ~= "" & "`version'" ~= "" {
	di _n "Do not specify both sourcedir() and version()."
	error 1
}
if "`sourcedir'" ~= "" & "`version'" == "" {
	* add final slash to input path if it does not exist
	if substr("`sourcedir'",-1,.) ~= "/" & substr("`sourcedir'",-1,.) ~= "\" {
		local inputpath `sourcedir'/
	}
	else local inputpath `sourcedir'
}
if "`sourcedir'" == "" {
	if "`dataversion'" == "production" local inputpath /data/cps/`lowersample'/epi/
	if "`dataversion'" == "old" & ("`lowersample'" == "org" | "`lowersample'" == "swa" | "`lowersample'" == "may") local inputpath /data/cps/org/epiold/stata/
	if "`dataversion'" == "old" & ("`lowersample'" == "basic" | "`lowersample'" == "march") local inputpath /data/cps/`lowersample'/epiold/stata/
	if "`dataversion'" == "local" local inputpath extracts/
}

* check inputpath
capture confirm file `inputpath'
if _rc ~= 0 {
	di _n "Current data source directory is invalid. Please specify valid sourcedir()."
	error 1
}

* announce version being used
if "`version'" ~= "" {
	di _n "Using `dataversion' version of the EPI CPS `samplename' extracts located in `inputpath'" _n
}
else {
	di _n "Using EPI CPS `samplename' extracts located in `inputpath'" _n
}


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
if "`dataversion'" == "old" & ("`lowersample'" == "org" | "`lowersample'" == "swa" | "`lowersample'" == "may" | "`lowersample'" == "march") {
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
		di _n "Mid-year samples are not available for the old EPI SWA/ORG/May/March samples, which are available annually"
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

* keep varlists for datasets
if "`keep'" ~= "" {
	if "`dataversion'" == "old" & ("`lowersample'" == "org" | "`lowersample'" == "swa") {
		local initkeeplist `keep' month mins orgwt
	}
	if "`dataversion'" == "old" & "`lowersample'" == "basic" {
		local initkeeplist `keep' month mins *wgt*
	}
	if "`dataversion'" == "old" & "`lowersample'" == "may" {
		local initkeeplist `keep' month finalwt
	}
	if "`dataversion'" == "old" & "`lowersample'" == "march" {
		local initkeeplist `keep' year wgt
	}
	if "`dataversion'" == "production" | "`dataversion'" == "local" {
		local initkeeplist `keep' year month minsamp *wgt*
	}
}


* process data
qui {
	* process old EPI Basic (quarterly)
	if "`dataversion'" == "old" & "`lowersample'" == "basic" {
		foreach quarterdate of numlist `minquarterdate'(1)`maxquarterdate' {
			local year = year(dofq(`quarterdate'))
			local shortyear = substr("`year'",3,2)
			local quarter = quarter(dofq(`quarterdate'))
			local inputfile cps`shortyear'q`quarter'.dta
			tempfile tmpdat
			!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
			use `tmpdat', clear
			if "`keep'" ~= "" {
				keepifexist `initkeeplist'
				local keeplist "`r(keeplist)'"
			}
			else local keeplist "_all"
			gen int year = `year'
			noi di "Processing CPS `samplename', " %tq `quarterdate' ": `keeplist'"
			tempfile quarterlydata`quarterdate'
			save `quarterlydata`quarterdate''
		}
		local counter = 0
		foreach quarterdate of numlist `minquarterdate'(1)`maxquarterdate' {
			local counter = `counter' + 1
			noi di "Loading CPS `samplename', " %tq `quarterdate'
			if `counter' == 1 use `quarterlydata`quarterdate'', clear
			else append using `quarterlydata`quarterdate''
		}
	}
	* process all other datasets (annual, or monthly)
	else {
		foreach year of numlist `minyear'(1)`maxyear' {
			* determine whether full year or not
			* here full year really just means whether the requested year is a single file
			local fullyear = 0
			local counter = 0
			foreach month of numlist `monthlist`year'' {
				local counter = `counter' + 1
			}
			if `counter' == 12 local fullyear = 1
			else if "`lowersample'" == "march" local fullyear = 1

			if `fullyear' == 1 {
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
				if "`dataversion'" == "old" & "`lowersample'" == "march" {
					local inputfile cps_march_`year'.dta
				}

				tempfile tmpdat
				!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
				use `initkeeplist' using `tmpdat', clear
				ds _all
				if "`keep'" ~= "" local keeplist "`r(varlist)'"
				else local keeplist "_all"
				if "`dataversion'" == "old" & "`lowersample'" ~= "march" gen int year = `year'
				if "`lowersample'" == "march" | "`lowersample'" == "may" noi di "Processing CPS `samplename', `year': `keeplist'
				else noi di "Processing CPS `samplename', `year'm1-`year'm12: `keeplist'"
				tempfile annualdata`year'
				save `annualdata`year''
			}
			* monthly files will be either production or local
			else {
				* determine whether annual files exist
				capture confirm file `inputpath'epi_cps`lowersample'_`year'.dta.zip
				* if annual exists, use appropriate months from that file
				if _rc == 0 {
					local inputfile epi_cps`lowersample'_`year'.dta
					tempfile tmpdat
					!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
					foreach month of numlist `monthlist`year'' {
						use if month == `month' using `tmpdat', clear
						if "`keep'" ~= "" {
							keepifexist `initkeeplist'
							local keeplist "`r(keeplist)'"
						}
						else local keeplist "_all"
						noi di "Processing CPS `samplename', `year'm`month': `keeplist'"
						tempfile monthlydata`month'
						save `monthlydata`month''
					}
				}
				* if annual does not exist, try monthly files
				else {
					foreach month of numlist `monthlist`year'' {
						local inputfile epi_cps`lowersample'_`year'_`month'.dta
						tempfile tmpdat
						!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
						use `tmpdat', clear
						if "`keep'" ~= "" {
							keepifexist `initkeeplist'
							local keeplist "`r(keeplist)'"
						}
						else local keeplist "_all"
						noi di "Processing CPS `samplename', `year'm`month': `keeplist'"
						tempfile monthlydata`month'
						save `monthlydata`month''
					}
				}
				* combine monthly files into annual file
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
		* combine all files
		local counter = 0
		foreach year of numlist `minyear'(1)`maxyear' {
			local counter = `counter' + 1
			local commalist: di subinstr("`monthlist`year''"," ",",",.)
			local commalist `commalist',.
			local minmonth = min(`commalist')
			local maxmonth = max(`commalist')
			if `counter' == 1 local linebreak _n
			else local linebreak
			if "`lowersample'" == "march" | "`lowersample'" == "may" noi di `linebreak' "Loading CPS `samplename', `year'"
			else noi di `linebreak' "Loading CPS `samplename', `year'm`minmonth'-`year'm`maxmonth'"
			if `counter' == 1 use `annualdata`year'', clear
			else append using `annualdata`year''
		}
	}

} // end quietly


end
