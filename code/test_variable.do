/******************************************************************************

Use this script as a template to test the generation of new variables
from the raw data.

(1) Write a variable generation do-file that uses the raw source data.
Example: code/variables/generate_wbhom.do

(2) Loop through the data month-by-month:
		(a) merge the extracts and raw data, keeping all necessary variables
		(b) run the variable generatinon do-file
		(c) save the data

(3) Append all the processed data together and analyze the results. Usually crosstabs of frequencies and shares give a good sense of where any problems are.

******************************************************************************/



*******************************************************************************
* Example based on code/variables/generate_wbhom.do
*******************************************************************************
* Process the data month-by-month
* define beginning and end dates
local begdate = tm(2021m1)
local enddate = tm(2021m12)

global marchcps = 0
global monthlycps = 1
global maycps = 0
global earnerinfo = 0
global basicfile = 0


foreach d of numlist `begdate'/`enddate'{
	* define year and month of data
	local year = year(dofm(`d'))
	local month = month(dofm(`d'))

	* load appropriate data depending on date
	* note that we need to do this conditionally on the date because we
	* need to keep certain variables associated with certain dates.
	*if tm(2003m1) <= `d' & `d' <= tm(2004m4) {
	*	merge_rawextracts, begin(`year'm`month') end(`year'm`month') keepraw(ptdtrace) keepextracts(hispanic basicwgt) sample(basic) version(local)
	*}
	if tm(2021m1) <= `d' & `d' <= tm(2021m2) {
		merge_rawextracts, begin(`year'm`month') end(`year'm`month') keepraw(peio1ocd) keepextracts(basicwgt) sample(basic) /*version(local)*/ 
		*gen ptdtrace = prdtrace
	}
	if tm(2021m3) <= `d' & `d' <= tm(2021m12) {
		merge_rawextracts, begin(`year'm`month') end(`year'm`month') keepraw(ptio1ocd) keepextracts(basicwgt) sample(basic) /*version(local)*/
	}

	* run variable generation code
	global date = `d'
	do /projects/jkandra/epiextracts/code/variables/generate_occcode.do
	do /projects/jkandra/epiextracts/code/variables/generate_occ90.do
	do /projects/jkandra/epiextracts/code/variables/generate_occ10.do
	do /projects/jkandra/epiextracts/code/variables/generate_occ18.do


	* save month of data
	tempfile month`d'
	save `month`d''
}

* Load all processed data back into memory
di _n(2) "Loading into memory processed data..."
foreach d of numlist `begdate'/`enddate' {
	di %tm `d'
	if `d' == `begdate' use `month`d'', clear
	else append using `month`d''
}

* Analyze data
/* create a monthly time variable
gen monthdate = ym(year,month)
format %tm monthdate

* examine raw frequencies
tab monthdate wbhom, m

* examine sample-weighted shares
tab monthdate wbhom [aw=basicwgt], m nofreq row
