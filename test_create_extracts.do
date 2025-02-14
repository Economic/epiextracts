************************************************************************
* master.do
* DESC: Required globals usually defined by master.do
* Call do file one its one
************************************************************************

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
global dataversion 1.0.61


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
* Unicon data already in Stata format
global uniconbasic /data/cps/basic/unicon/
global uniconorg /data/cps/org/unicon/

*************************************************************************
* NAME: create_extracts
* DESC: Create uniform EPI extracts of CPS basic monthlies and May/ORG
* Called by master.do
*************************************************************************
* deal with dates
local begindate = tm(2023m1)
local enddate = tm(2023m12)
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

* for 2025, temporarily use 2025-2024 CBO projected growth rate
* from https://www.cbo.gov/system/files/2025-01/51135-2025-01-Economic-Projections.xlsx
local cbo2024 = 313.6
local cbo2025 = 320.6
sum cpiurs_extended if year == 2024
local cpi2024 = r(mean)
moreobs 1
replace year = 2025 if year == .
replace cpiurs_extended = `cpi2024' * (`cbo2025' / `cbo2024') if year == 2025

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
order year cpiurs_extended wage_lower wage_upper
tempfile extremewages
save `extremewages'
global extremewages `extremewages'
export delimited using ${docs}misc/extremewages.csv, replace datafmt novarnames
* because Stata will not (!) export variable labels to a csv file
! sed -i -e '1iYear,CPI-U-RS - extended,Lower wage limit ($),Upper wage limit ($)' ${docs}misc/extremewages.csv
 
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

    /*bunch of irrelevant code*/


	* 1976 and later, process monthly basic and possibly monthly ORG
	if `year' >= 1976 {
		global marchcps = 0
		global monthlycps = 1
		global maycps = 0
		global earnerinfo = 0
		global basicfile = 0

		*/* define current month
			global date = tm(`year'm`month')*/

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
		if `counter' == 12 & `year' != 2023 {
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

		else if `counter' == 12 & `year' == 2023 {
			* warning: this will cause $date == 2023m12 and the $tm(2023m3) in weekpay.do will never run
			* create full calendar year of Basic with old tc prodcedure to adjust wages
			load_epiextracts, begin(2022m4) end(2022m12) sample(basic) version(local)
			foreach month of numlist 1 / 3 {
				append using `basic_month`month''
			}
			global earnerinfo = 0
			global basicfile = 1

			* do something about date, redefine?
            di $date

            break

			do ${code}adjust_wages.do
				
			tempfile basicadjusted
			save `basicadjusted'

			if `orgexists' == 1 {
				* create full calendar year of ORG to adjust wages
				load_epiextracts, begin(2022m4) end(2022m12) sample(org) version(local)
				foreach month of numlist 1 / 3 {
					append using `org_month`month''
				}
				global earnerinfo = 1
				global basicfile = 0

                * do something about date again
                
				do ${code}adjust_wages.do
				
				tempfile orgadjusted
				save `orgadjusted'
			}

			*take mean above topcode and apply it to all topcoded observations (regardless minsamp)
			* create full calendar year of Basic with new tc procedure to adjust wages
			load_epiextracts, begin(2024m1) end(2024m3) sample(basic) version(local)
			foreach month of numlist 4 / 12 {
				append using `basic_month`month''
			}
			global earnerinfo = 0
			global basicfile = 1
				
			*account for topcoding change in 2023/2024 where outgoing rotation groups are making their way through the changed procedure
			sum weekpay_noadj if tc_weekpay == 1
			local tc_value = r(mean)

			replace weekpay_noadj = tc_value if tc_weekpay == 1 & minsamp == 8

            * date will be 2023m12, so don't have to do anything about date

			do ${code}adjust_wages.do
			
			append using `basicadjusted'

			notes drop _dta
			notes _dta: EPI CPS Basic Monthly Extracts, Version $dataversion
			label data "EPI CPS Basic Monthly Extracts, Version $dataversion"
			saveold ${extracts}epi_cpsbasic_`year'.dta, replace version(13)

			if `orgexists' == 1 {
				* create full calendar year of ORG to adjust wages
				load_epiextracts, begin(2024m1) end(2024m3) sample(org) version(local)
				foreach month of numlist `monthlist`year'' {
					append using `org_month`month''
				}
				global earnerinfo = 1
				global basicfile = 0

				*account for topcoding change in 2023/2024 where outgoing rotation groups are making their way through the changed procedure
				sum weekpay_noadj if tc_weekpay == 1
				local tc_value = r(mean)

				replace weekpay_noadj = tc_value if tc_weekpay == 1 & minsamp == 8


				do ${code}adjust_wages.do

				append using `orgadjusted'
					
				notes drop _dta
				notes _dta: EPI CPS ORG Extracts, Version $dataversion
				label data "EPI CPS ORG Extracts, Version $dataversion"
				saveold ${extracts}epi_cpsorg_`year'.dta, replace version(13)
			}			

		}
		
		* after lunch update planner for yesterday, today, and next week
 
		* otherwise deal with partial year
		else {
			* error message if year == 2023 and counter != 12
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
