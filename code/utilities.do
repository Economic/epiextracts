* Utility programs called by master.do


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
  else local tempbegindate = tm(1989m1)
  foreach date of numlist `tempbegindate'/`enddate' {
    di "Census CPS " %tm `date' " ... converting to Stata"
		* Use process_censusbasic function to convert the data to Stata
    process_censusbasic, month(`date')
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
syntax, month(string)

di "Running process_censusbasic, month(`month')"

end

* create both basic monthly and ORG extracts
capture program drop create_extracts
program define create_extracts
syntax, begin(string) end(string)

* code to determine months and years to process
* output should be local monthlist`year'


* process all data
foreach year of numlist `yearlist' {

	* first process annual may if necessary
	if `year' < 1979 {
		* unzip may
		* use may
		* run programs
		* save data
		*saveold epi_cpsmay_`year'.dta, replace version(13)
		di "test: saveold epi_cpsmay_`year'.dta, replace version(13)"
	}

	* 1976 and later, process monthly basic and possibly monthly ORG
	if `year' >= 1976 {
		* determine list of months to process for each year
		* some code that results in `monthlist`year''

		* start a counter to help determine if we have a full year of data
		local counter = 0
		foreach month of numlist `monthlist`year'' {
			local counter = `counter' + 1

			* indicator to determine if we use separate ORG files
			if tm(`year'm`month') < tm(1983m1) local separateorg == 1
			else local separateorg = 0

			* identify which files to use and use statement

			* create basic monthly extract
			* load basic monthly data
			* save extract
			tempfile basic_month`month'
			*save `basic_month`month''
			di "test: saving temp basic `year'-`month': `basic_month`month''"

			* create org extract
			* load org data if necessary
			* save extract
			tempfile org_month`month'
			*save `org_month`month''
			di "test: saving temp org `year'-`month': `org_month`month''"

			* clean up decompressed files

		}

		* combine all months into full year if necessary
		if `counter' == 12 {
			forvalues month = 1 / 12 {
				if `month' == 1 use `basic_month`month'', clear
				else append using `basic_month`month''
			}
			save epi_cpsbasic_`year'.dta, replace
			forvalues month = 1 / 12 {
				if `month' == 1 use `org_month`month'', clear
				else append using `org_month`month''
			}
			save epi_cpsorg_`year'.dta, replace
		}
		* otherwise save individual months
		else {
			foreach month of numlist `monthlist`year'' {
				use `basic_month`month'', clear
				epi_cpsbasic_`year'_`month'.dta, replace

				use `org_month`month'', clear
				epi_cpsorg_`year'_`month'.dta, replace
			}
		}

	}
}





end
