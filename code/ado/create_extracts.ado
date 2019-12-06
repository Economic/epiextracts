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

* check order of dates
if `begindate' > `enddate' {
	di _n "Choose an ending date after the beginning date"
	error 1
}

* create list of months for each year to process
foreach date of numlist `begindate'(1)`enddate' {
	local year = year(dofm(`date'))
	local month = month(dofm(`date'))
	local monthlist`year' `monthlist`year'' `month'
}

if `begindate' < tm(1962m1) {
	di _n "No CPS data available for" %tm `begindate'
	error 1
}

* preliminary data
* cpi levels and extreme wage values
import delimited using ${suppdata}cpiurs_extended.csv, clear varnames(1)
keep if year >= 1962
assert year ~= .

* for 2019, temporiarly use 2019-2018 CBO projected growth rate
* from https://www.cbo.gov/system/files/2019-01/51135-2019-01-economicprojections.xlsx
local cbo2018 = 251.202
local cbo2019 = 256.503
sum cpiurs_extended if year == 2018
local cpi2018 = r(mean)
moreobs 1
replace year = 2019 if year == .
replace cpiurs_extended = `cpi2018' * (`cbo2019' / `cbo2018') if year == 2019

replace cpiurs_extended = round(cpiurs_extended,0.1)
sum cpiurs_extended if year == 1989
scalar cpibase = r(mean)
gen wage_lower = 0.50 * cpiurs_extended / cpibase
gen wage_upper = 100 * cpiurs_extended / cpibase
replace wage_lower = round(wage_lower,0.01)
replace wage_upper = round(wage_upper,0.01)
keep year cpiurs_extended wage_lower wage_upper
compress
format %4.1f cpiurs_extended
format %4.2f wage_lower
format %4.2f wage_upper
tempfile extremewages
save `extremewages'
global extremewages `extremewages'
* add table to documentation folder
export delimited using ${docs}misc/extremewages.csv, replace datafmt novarnames

* state codes
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
global stategeocodes `stategeocodes'

* process all data
foreach year of numlist `minyear'(1)`maxyear' {
	* reset survey sample settings
	global marchcps = 0
	global monthlycps = 0
	global maycps = 0
	global earnerinfo = 0
	global basicfile = 0

	* process annual march if necessary
	if 1962 <= `year' & `year' <= 2018 {
		* survey sample settings
		global marchcps = 1
		global monthlycps = 0
		global maycps = 0
		global earnerinfo = 0
		global basicfile = 0

		* for March CPS, use month=3 (march)
		global date = tm(`year'm3)

		if 1962 <= `year' & `year' <= 1997 {
			local inputpath ${uniconmarch}
			local inputfile unicon_march_`year'.dta
		}
		if 1998 <= `year' {
			local inputpath ${censusmarchstata}
			local inputfile cpsmarch_`year'.dta
		}

		* unzip and load source data into memory
		* 2014 is an exception with redesigned and traditional files:
		if `year' == 2014 {
			tempfile tmpdat_t tmpdat_r
			!unzip -p "`inputpath'cpsmarch_2014.dta.zip" > `tmpdat_r'
			!unzip -p "`inputpath'cpsmarch_2014_traditional.dta.zip" > `tmpdat_t'
			use `tmpdat_r', clear
			gen byte redesign = 1
			append using `tmpdat_t'
			replace redesign = 0 if redesign == .
		}
		else {
			tempfile tmpdat
			!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
			use `tmpdat', clear
		}

		* run key programs
		do ${code}sample_cpsbasic.do
		do ${code}generate_variables.do
		do ${code}keep_variables.do

		* save data
		compress
		notes drop _dta
		notes _dta: EPI CPS March Extracts, Version $dataversion
		label data "EPI CPS March Extracts, Version $dataversion"
		saveold ${extracts}epi_cpsmarch_`year'.dta, replace version(13)
	}

	* process annual may if necessary
	if 1973 <= `year' & `year' <= 1981 {
		* survey sample settings
		global marchcps = 0
		global monthlycps = 0
		global maycps = 1
		global earnerinfo = 1
		global basicfile = 0

		* for May CPS, use month=5 (may)
		global date = tm(`year'm5)

		* input files
		local inputpath ${uniconmay}
		local inputfile unicon_may_`year'.dta

		* load data
		tempfile tmpdat
		!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
		use `tmpdat', clear

		* run key may programs
		do ${code}sample_cpsbasic.do
		do ${code}generate_variables.do
		do ${code}keep_variables.do

		* adjust wage variables (top-codes, hours, extreme values)
		do ${code}adjust_wages.do

		* save data
		compress
		notes drop _dta
		notes _dta: EPI CPS May Extracts, Version $dataversion
		label data "EPI CPS May Extracts, Version $dataversion"
		saveold ${extracts}epi_cpsmay_`year'.dta, replace version(13)
	}


	* 1976 and later, process monthly basic and possibly monthly ORG
	if `year' >= 1976 {
		global marchcps = 0
		global monthlycps = 1
		global maycps = 0
		global earnerinfo = 0
		global basicfile = 0

		* start a counter to help determine if we have a full year of data
		local counter = 0
		foreach month of numlist `monthlist`year'' {
			local counter = `counter' + 1

			* define current month
			global date = tm(`year'm`month')

			* indicator for using basic monthly file
			global basicfile = 1

			* indicator for existence of ORG files
			if `year' >= 1979 local orgexists = 1
			else local orgexists = 0

			* indicator for ORG files being separate from basic files
			if 1979 <= `year' & `year' <= 1983 local separateorg = 1
			else local separateorg = 0

			* indicator if file contains earner info
			if `year' >= 1982 global earnerinfo = 1
			else global earnerinfo = 0

			* file names of basic source data in stata format
			if 1976 <= `year' & `year' <= 1993 {
				local inputpath ${uniconbasic}
				local inputfile unicon_basic_`year'_`month'.dta
			}
			if 1994 <= `year' {
				local inputpath ${censusbasicstata}
				local inputfile cps_`year'_`month'.dta
			}

			* unzip and load source data into memory
			tempfile tmpdat
			!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
			use `tmpdat', clear

			* run key basic/org programs
			do ${code}sample_cpsbasic.do
			do ${code}generate_variables.do
			do ${code}keep_variables.do

			* limit sample to certain variables for debugging
			if "`keeponly'" ~= "" keep year month minsamp basicwgt orgwgt `keeponly'

			* save basic monthly extract
			tempfile basic_month`month'
			save `basic_month`month''

			* save separate org subsample
			if `orgexists' == 1 & `separateorg' == 0 {
				* keep org subsample
				do ${code}sample_cpsorg.do

				* limit sample to certain variables for debugging
				if "`keeponly'" ~= "" keep year month minsamp basicwgt orgwgt `keeponly'

				tempfile org_month`month'
				save `org_month`month''
			}

			* process separate 1979-1981 ORG
			if `orgexists' == 1 & `separateorg' == 1 {
				* indicator for using basic monthly file
				global basicfile = 0

				* indicator if file contains earner info
				global earnerinfo = 1

				* file names of ORG source data in stata format
				local inputpath ${uniconorg}
				local inputfile unicon_org_`year'_`month'.dta

				tempfile tmpdat
				!unzip -p "`inputpath'`inputfile'.zip" > `tmpdat'
				use `tmpdat', clear

				* run key basic/org programs
				do ${code}sample_cpsbasic.do
				do ${code}generate_variables.do
				do ${code}keep_variables.do

				* keep org subsample
				do ${code}sample_cpsorg.do

				* limit sample to certain variables for debugging
				if "`keeponly'" ~= "" keep year month minsamp orgwgt `keeponly'

				* save basic monthly extract
				tempfile org_month`month'
				save `org_month`month''

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

			* adjust wage variables (top-codes, hours, extreme values)
			if `year' >= 1982 global earnerinfo = 1
			else global earnerinfo = 0
			global basicfile = 1
			do ${code}adjust_wages.do

			notes drop _dta
			notes _dta: EPI CPS Basic Monthly Extracts, Version $dataversion
			label data "EPI CPS Basic Monthly Extracts, Version $dataversion"
			saveold ${extracts}epi_cpsbasic_`year'.dta, replace version(13)

			* ORG, if exists
			if `orgexists' == 1 {
				forvalues month = 1 / 12 {
					if `month' == 1 use `org_month`month'', clear
					else append using `org_month`month''
				}
				compress

				* adjust wage variables (top-codes, hours, extreme values)
				global earnerinfo = 1
				global basicfile = 0
				do ${code}adjust_wages.do

				notes drop _dta
				notes _dta: EPI CPS ORG Extracts, Version $dataversion
				label data "EPI CPS ORG Extracts, Version $dataversion"
				saveold ${extracts}epi_cpsorg_`year'.dta, replace version(13)
			}
		}

		* otherwise deal with partial year
		else {
			local prevyear = `year' - 1
			local monthcount = 0
			foreach month of numlist `monthlist`year'' {
				local monthcount = `monthcount' + 1
			}
			local beginmonth = `monthcount' + 1

			* create full calendar year of basic to adjust wages
			load_epiextracts, begin(`prevyear'm`beginmonth') end(`prevyear'm12) sample(basic) version(local)
			foreach month of numlist `monthlist`year'' {
				append using `basic_month`month''
			}
			global earnerinfo = 1
			global basicfile = 1
			do ${code}adjust_wages.do
			tempfile basicadjusted
			save `basicadjusted'

			* create full calendar year of ORG to adjust wages
			load_epiextracts, begin(`prevyear'm`beginmonth') end(`prevyear'm12) sample(org) version(local)
			foreach month of numlist `monthlist`year'' {
				append using `org_month`month''
			}
			global earnerinfo = 1
			global basicfile = 0
			do ${code}adjust_wages.do
			tempfile orgadjusted
			save `orgadjusted'

			* process individual months
			foreach month of numlist `monthlist`year'' {
				* process basic
				use if month == `month' & year == `year' using `basicadjusted', clear
				compress
				notes drop _dta
				notes _dta: EPI CPS Basic Monthly Extracts, Version $dataversion
				label data "EPI CPS Basic Monthly Extracts, Version $dataversion"
				saveold ${extracts}epi_cpsbasic_`year'_`month'.dta, replace version(13)

				* process ORG, if exists
				if `orgexists' == 1 {
					use if month == `month' & year == `year' using `orgadjusted', clear
					compress
					notes drop _dta
					notes _dta: EPI CPS ORG Extracts, Version $dataversion
					label data "EPI CPS ORG Extracts, Version $dataversion"
					saveold ${extracts}epi_cpsorg_`year'_`month'.dta, replace version(13)
				}

			}
		}

	}
}


end
