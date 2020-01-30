*************************************************************************
* NAME: load_epiextracts
* DESC: Load CPS extracts into memory.
* Useful for analysis/testing. Used in documentation creation.
* Not used in the creation of extracts.
*************************************************************************
capture program drop load_epiextracts
program define load_epiextracts
syntax, sample(string) [years(numlist) beginmonth(string) endmonth(string) keep(string) version(string) sourcedir(string)]

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
	if "`dataversion'" == "production" local inputpath ${epiextracts`lowersample'dir}

	* old and local extracts (for development only)
	if "`dataversion'" == "old" & inlist("`lowersample'", "org", "swa", "may") local inputpath /data/cps/org/epiold/stata/
	if "`dataversion'" == "old" & inlist("`lowersample'", "basic", "march") local inputpath /data/cps/`lowersample'/epiold/stata/
	if "`dataversion'" == "local" local inputpath extracts/
}

* deal with dates
if "`years'" == "" & "`months'" == "" {
	di _n "Specify the timeframe of the data in years() or months()."
	error 1
}
if "`years'" != "" & "`months'" != "" {
	di _n "Select the timeframe using either years() or months(), but not both."
	error 1
}
if "`dataversion'" == "old" & "`years'" == "" {
	di _n "If using the old EPI extracts, specify the timeframe of the sample in years()."
	error 1
}
if inlist("`lowersample'", "march", "may") & "`years'" == "" {
	di _n "Select the timeframe of the CPS `samplename' data in years()."
	error 1
}

local fullyear = 1
if "`months'" != "" {
	local minmonth = month(dofm(`beginmonth'))
	local maxmonth = month(dofm(`endmonth'))
	local minyear = year(dofm(`beginmonth'))
	local maxyear = year(dofm(`endmonth'))
	local years `minyear'(1)`maxyear'
	if "`minmonth'" != 1 | "`maxmonth'" != 12 local fullyear = 0
}

* keep varlists for datasets
if "`keep'" ~= "" {
	if "`dataversion'" == "old" & inlist("`lowersample'", "org", "swa") {
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
else {
	local initkeeplist _all
}

if "`dataversion'" == "old" & "`lowersample'" == "basic" {
	load_quarters, years(`years') sample(`lowersample') samplename(`samplename') inputpath(`inputpath') keep(`initkeeplist') dataversion(`dataversion')
}
else {
	load_years, years(`years') sample(`lowersample') samplename(`samplename') inputpath(`inputpath') keep(`initkeeplist') dataversion(`dataversion')
}



stop 

* process data
*qui {
	* process old EPI Basic (quarterly)
	if "`dataversion'" == "old" & "`lowersample'" == "basic" {
		foreach quarterdate of numlist `minquarterdate'(1)`maxquarterdate' {
			local year = year(dofq(`quarterdate'))
			local shortyear = substr("`year'",3,2)
			local quarter = quarter(dofq(`quarterdate'))
			local inputfile cps`shortyear'q`quarter'.dta

			* check inputpath
			capture confirm file "`inputpath'`inputfile'.zip"
			if _rc ~= 0 {
				noi di _n "Current data source directory is invalid."
				noi di "Please specify valid sourcedir() containing `inputfile'.zip."
				error 1
			}

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
			else if "`lowersample'" == "may" local fullyear = 1

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

				if "`dataversion'" == "old"	capture confirm file "`inputpath'`inputfile'.zip"
				else capture confirm file "`inputpath'`inputfile'"

				if _rc ~= 0 {
					noi di _n "Current data source directory is invalid."
					noi di "Please specify valid sourcedir() containing `inputfile'"
					error 1
				}

				* use appropriate data: unzip if old
				if "`dataversion'" == "old" {
					* couldn't figure out how to pipe zip files for all versions of Windows
					* would love better code than this:
					if c(os) == "Windows" {
						local wd = c(pwd)
						cd "`c(tmpdir)'"
						unzipfile "`inputpath'`inputfile'.zip"
						tempfile tmpdat
						copy `inputfile' `tmpdat'
						erase `inputfile'
						cd "`wd'"
					}
					else {
						tempfile tmpdat
						!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
					}
					use `initkeeplist' using `tmpdat', clear
				}
				else use `initkeeplist' using "`inputpath'`inputfile'", clear
				ds _all
				if "`keep'" ~= "" local keeplist "`r(varlist)'"
				else local keeplist "_all"
				if "`dataversion'" == "old" & "`lowersample'" ~= "march" gen int year = `year'
				if "`lowersample'" == "march" | "`lowersample'" == "may" noi di "Processing CPS `samplename', `year': `keeplist'
				else noi di "Processing CPS `samplename', `year'm1-`year'm12: `keeplist'"
				tempfile annualdata`year'
				save `annualdata`year''
			}
			* no for non-full-year sample: monthly files will be either production or local
			else {
				* determine whether annual files exist
				capture confirm file "`inputpath'epi_cps`lowersample'_`year'.dta"
				* if annual exists, use appropriate months from that file
				if _rc == 0 {
					local inputfile epi_cps`lowersample'_`year'.dta
					foreach month of numlist `monthlist`year'' {
						use if month == `month' using "`inputpath'`inputfile'", clear
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
						capture confirm file "`inputpath'`inputfile'"
						if _rc ~= 0 {
							noi di _n "Current data source directory is invalid."
							noi di "Please specify valid sourcedir() containing `inputfile'.zip."
							error 1
						}
						use "`inputpath'`inputfile'", clear
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

		* announce version being used
		if "`dataversion'" == "local" | "`dataversion'" == "production" {
			local extractversion: char _dta[note1]
		}
		else if "`dataversion'" == "old" {
			local extractversion old EPI CPS `samplename' extracts
		}
		noi di _n "Using `extractversion', located in `inputpath'"
	}

*} // end quietly


end



capture program drop load_quarters
program define load_quarters
syntax, years(numlist) sample(string) samplename(string) inputpath(string) keep(string) dataversion(string)
	if "`sample'" != "basic" & "`dataversion'" != "old" error 1
	qui {
		foreach year of numlist `years' {
			local shortyear = substr("`year'",3,2)
			forvalues quarter = 1 / 4 {
				noi confirm_load, inputfile(cps`shortyear'q`quarter'.dta) inputpath(`inputpath') keep(`keep') dataversion(`dataversion')
				local keeplist `r(keeplist)'
				gen int year = `year'
				noi di "Processing CPS `samplename', " %tq tq(`year'q`quarter') ": `keeplist'"
				tempfile data`year'q`quarter'
				save `data`year'q`quarter''
			}
		}

		local counter = 0
		foreach year of numlist `years' {
			forvalues quarter = 1 / 4 {
				local counter = `counter' + 1
				noi di "Loading CPS `samplename', " %tq tq(`year'q`quarter')
				if `counter' == 1 use `data`year'q`quarter'', clear
				else append using `data`year'q`quarter''
			}
		}
	}
end

capture program drop load_years
program define load_years
syntax, years(numlist) sample(string) samplename(string) inputpath(string) keep(string) dataversion(string)
	qui {
		foreach year of numlist `years' {
			local shortyear = substr("`year'",3,2)

			if "`dataversion'" == "local" | "`dataversion'" == "production" local inputfile epi_cps`sample'_`year'.dta
			local shortyear = substr("`year'",3,2)
			if "`dataversion'" == "old" & "`sample'" == "org" {
				local inputfile org`shortyear'c.dta
			}
			if "`dataversion'" == "old" & "`sample'" == "swa" {
				local inputfile wage`shortyear'c.dta
			}
			if "`dataversion'" == "old" & "`sample'" == "may" {
				local inputfile may`shortyear'c.dta
			}
			if "`dataversion'" == "old" & "`sample'" == "march" {
				local inputfile cps_march_`year'.dta
			}

			noi confirm_load, inputfile(`inputfile') inputpath(`inputpath') keep(`keep') dataversion(`dataversion')
			local keeplist `r(keeplist)'
			if "`dataversion'" == "old" & "`lowersample'" ~= "march" gen int year = `year'
			if "`lowersample'" == "march" | "`lowersample'" == "may" noi di "Processing CPS `samplename', `year': `keeplist'
			else noi di "Processing CPS `samplename', `year'm1-`year'm12: `keeplist'"
			tempfile data`year'
			save `data`year''
		}

		local counter = 0
		foreach year of numlist `years' {
			local counter = `counter' + 1
			if `counter' == 1 local linebreak _n
			else local linebreak
			if "`lowersample'" == "march" | "`lowersample'" == "may" noi di `linebreak' "Loading CPS `samplename', `year'"
			else noi di `linebreak' "Loading CPS `samplename', `year'm1-`year'm12"	
			if `counter' == 1 use `data`year'', clear
			else append using `data`year''
		}
	}
end

capture program drop confirm_load 
program define confirm_load, rclass
syntax, inputfile(string) inputpath(string) keep(string) dataversion(string)
	qui {

		if "`dataversion'" == "old" {
			capture confirm file "`inputpath'`inputfile'.zip"
			if _rc ~= 0 {
				noi di _n "Current data source directory is invalid."
				noi di "Please specify valid sourcedir() containing `inputfile'.zip."
				error 1
			}
			tempfile tmpdat
			!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
			use `tmpdat', clear
			if "`keep'" ~= "_all" {
				keepifexist `keep'
			}
		}
		else {
			capture confirm file "`inputpath'`inputfile'"
			if _rc ~= 0 {
				noi di _n "Current data source directory is invalid."
				noi di "Please specify valid sourcedir() containing `inputfile'."
				error 1
			}
			use `keep' using "`inputpath'`inputfile'", clear
		}

		if "`keep'" == "_all" return local keeplist _all
		else {
			fvexpand _all
			return local keeplist `r(varlist)'
		}
	}
end



