*************************************************************************
* NAME: merge_rawextracts
* DESC: Merge raw data to extracts
* Just a useful utility; not used in the creation of extracts
* Currently most paths are hard-coded; will add options to change this in
* future versions
*************************************************************************
capture program drop merge_rawextracts
program define merge_rawextracts
syntax, begin(string) end(string) sample(string) [version(string)] keepraw(string) keepextracts(string)

* determine sample
local lowersample = lower("`sample'")
if "`lowersample'" == "org" local samplename ORG
else if "`lowersample'" == "basic" local samplename Basic
else if "`lowersample'" == "may" local samplename May
else {
	di _n "You must specify Basic or ORG or May sample."
	error 1
}

* determine version
local dataversion = lower("`version'")
if "`version'" == "" local dataversion "production"
if "`dataversion'" ~= "production" & "`dataversion'" ~= "local" {
	di _n "Version must be local or production"
	error 1
}

* determine path of extracts version and sample
if "`dataversion'" == "production" local inputpathextracts /data/cps/`lowersample'/epi/
if "`dataversion'" == "local" local inputpathextracts extracts/


di _n "Using `dataversion' version of the EPI CPS `samplename' extracts located in `inputpathextracts'" _n

* deal with dates
local begindate = tm(`begin')
local enddate = tm(`end')
local minyear = year(dofm(`begindate'))
local maxyear = year(dofm(`enddate'))
local minmonth = month(dofm(`begindate'))
local maxmonth = month(dofm(`enddate'))



qui if "`lowersample'" == "may" {
	forvalues year = `minyear'/`maxyear' {

		* date check and file names
		if `year' < 1973 | `year' > 1981 {
			noi di _n "CPS May `year' not available"
			error 1
		}
		else {
			local inputpathraw /data/cps/`lowersample'/unicon/
			local inputfileraw unicon_`lowersample'_`year'.dta
		}
		local inputfileextracts epi_cps`lowersample'_`year'.dta

		* load extracts
		noi di "Processing `year' EPI CPS `samplename'"

		tempfile tmpextract
		!unzip -p "`inputpathextracts'`inputfileextracts'.zip" > `tmpextract'
		use unicon_recnum year month `keepextracts' using `tmpextract', clear
		tempfile extracts`year'
		save `extracts`year''

		* load raw
		noi di "Processing raw CPS `samplename' `year'"
		tempfile tmpraw
		!unzip -p "`inputpathraw'`inputfileraw'.zip" > `tmpraw'
		use recnum age `keepraw' using `tmpraw', clear
		* extracts sample restriction
		drop if age == .
		assert age >= 0
		keep recnum `keepraw'
		rename recnum unicon_recnum

		* merge data
		noi di "Merging raw and extracts `year'" _n
		merge 1:1 unicon_recnum using `extracts`year'', assert(3) nogenerate
		tempfile final`year'
		save `final`year''
	}

	* load merged data
	local counter = 0
	forvalues year = `minyear'/`maxyear' {
		local counter = `counter' + 1
		noi di "Loading merged raw and EPI CPS `samplename' `year' "
		if `counter' == 1 use `final`year'', clear
		else append using `final`year''
	}

} // end may


qui if "`lowersample'" == "basic" | "`lowersample'" == "org" {
	foreach date of numlist `begindate'(1)`enddate' {
		local year = year(dofm(`date'))
		local month = month(dofm(`date'))
		local monthlist`year' `monthlist`year'' `month'
	}
	forvalues year = `minyear'/`maxyear' {

		capture confirm file `inputpathextracts'epi_cps`lowersample'_`year'.dta.zip
		* if annual file exists, unzip it, save as temp
		if _rc == 0 {
			local inputfile epi_cps`lowersample'_`year'.dta
			tempfile tmpextract
			!unzip -p "`inputpathextracts'`inputfile'.zip" > `tmpextract'
			use `tmpextract', clear
			tempfile extracts`year'
			save `extracts`year''
		}
		* else, try monthly files
		else {
			foreach month of numlist `monthlist`year'' {
				capture confirm file `inputpathextracts'epi_cps`lowersample'_`year'_`month'.dta.zip
				if _rc == 0 {
					tempfile tmpextract
					!unzip -p "`inputpathextracts'`inputfile'.zip" > `tmpextract'
					use `tmpextract', clear
					tempfile monthlydata`month'
					save `monthlydata`month''
				}
				else {
					noi di "Data missing: `inputpathextracts'epi_cps`lowersample'_`year'_`month'.dta.zip"
					error _rc
				}
			}
			local counter = 0
			foreach month of numlist `monthlist`year'' {
				local counter = `counter' + 1
				if `counter' == 1 use `monthlydata`month'', clear
				else append using `monthlydata`month''
			}
			tempfile extracts`year'
			save `extracts`year''
		}

		* begin month counter
		local counter = 0
		foreach month of numlist `monthlist`year'' {
			local counter = `counter' + 1

			* identify date
			local date = tm(`year'm`month')

			* basic date checks and filenames
			if "`lowersample'" == "basic" {
				if `year' < 1976 {
					di _n "CPS Basic `year' not available"
					error 1
				}
				else if `year' <= 1993 {
					local inputpathraw /data/cps/basic/unicon/
					local inputfileraw unicon_basic_`year'_`month'.dta
				}
				else {
					local inputpathraw /data/cps/basic/census/stata/
					local inputfileraw cps_`year'_`month'.dta
				}
			}
			* org date checks and filenames
			if "`lowersample'" == "org" {
				if `year' < 1979 {
					di _n "CPS ORG `year' not available"
					error 1
				}
				else if `year' <= 1983 {
					local inputpathraw /data/cps/org/unicon/
					local inputfileraw unicon_org_`year'_`month'.dta
				}
				else if `year' >= 1984 & `year' <= 1993 {
					local inputpathraw /data/cps/basic/unicon/
					local inputfileraw unicon_basic_`year'_`month'.dta
				}
				else {
					local inputpathraw /data/cps/basic/census/stata/
					local inputfileraw cps_`year'_`month'.dta
				}
			}

			if tm(1976m1) <= `date' & `date' <= tm(1993m12) {
				local mergeidvars unicon_recnum
				if "`lowersample'" == "basic" local rawpullvars recnum age
				if "`lowersample'" == "org" local rawpullvars recnum age mis ernwgt
			}
			if tm(1994m1) <= `date' & `date' <= tm(2004m4) {
				local mergeidvars statefips hrhhid hrsersuf hrsample huhhnum pulineno
				local rawpullvars gestfips hrhhid hrsersuf hrsample huhhnum pulineno peage hrmis pworwgt
			}
			if tm(2004m5) <= `date' {
				if `date' <= tm(2012m4) local rawagevar peage
				if `date' >= tm(2012m5) local rawagevar prtage
				local mergeidvars statefips hrhhid hrhhid2 pulineno
				local rawpullvars gestfips hrhhid hrhhid2 pulineno `rawagevar' hrmis pworwgt
			}

			* load extracts
			noi di "Processing EPI CPS `samplename' `year'm`month'"
			use year month `mergeidvars' `keepextracts' if month == `month' using `extracts`year'', clear
			tempfile extractsm`date'
			save `extractsm`date''

			* load raw
			noi di "Processing raw CPS `samplename' `year'm`month'"

			tempfile tmpraw
			!unzip -p "`inputpathraw'`inputfileraw'.zip" > `tmpraw'
			use `rawpullvars' `keepraw' using `tmpraw', clear
			capture gen age = peage
			capture gen age = prtage
			capture gen orgwgt = pworwgt
			capture gen orgwgt = ernwgt
			capture gen minsamp = hrmis
			capture gen minsamp = mis
			capture gen statefips = gestfips
			capture gen unicon_recnum = recnum
			* extracts sample restriction
			if "`lowersample'" == "basic" {
				drop if age == . | age < 0
			}
			if "`lowersample'" == "org" {
				keep if minsamp == 4 | minsamp == 8
				keep if orgwgt > 0 & orgwgt ~= .
				keep if age >= 16 & age ~= .
			}
			* keep only desired variables
			keep `mergeidvars' `keepraw'

			* merge data
			noi di "Merging raw and extracts `year'm`month'" _n
			merge 1:1 `mergeidvars' using `extractsm`date'', assert(3) nogenerate
			tempfile finalm`date'
			save `finalm`date''
		}
	}
	* load merged data
	local counter = 0
	foreach date of numlist `begindate'(1)`enddate' {
		local counter = `counter' + 1
		local year = year(dofm(`date'))
		local month = month(dofm(`date'))
		noi di "Loading merged raw and EPI CPS `samplename' `year'm`month' "
		if `counter' == 1 use `finalm`date'', clear
		else append using `finalm`date''
	}

} // end basic/org

end
