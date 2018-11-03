/******************************************************************************

Use this script as a template to test the generation of new variables
from the raw data.

(1) Write a variable generation do-file that uses the raw source data.
Example: code/variables/generate_wbhom.do

(2) Merge the extracts and raw data for the appropriate months and keep all
necessary variables. Use the merge_rawextracts function to make this easy.
Save this data.

(3) Loop through this data by month, calling the variable generation do-file.
Save each month of processed data.

(4) Append all the processed data together and analyze the results. Usually
crosstabs of frequencies and shares give a good sense of where any problems are.

******************************************************************************/



*******************************************************************************
* Example based on code/variables/generate_wbhom.do
*******************************************************************************
* Load and save the data
merge_rawextracts, begin(2003m1) end(2004m4) keepraw(ptdtrace) keepextracts(hispanic basicwgt) sample(basic) version(local)
tempfile 20032004
save `20032004'

merge_rawextracts, begin(2004m5) end(2005m7) keepraw(prdtrace) keepextracts(hispanic basicwgt) sample(basic) version(local)
gen ptdtrace = prdtrace
tempfile 20042005
save `20042005'

merge_rawextracts, begin(2005m8) end(2018m9) keepraw(ptdtrace) keepextracts(hispanic basicwgt) sample(basic) version(local)
append using `20032004'
append using `20042005'

save /tmp/allthedata, replace


* Process the data month-by-month
* define beginning and end dates
local begdate = tm(2003m1)
local enddate = tm(2018m9)

foreach d of numlist `begdate'/`enddate'{
	* define appropriate year and month of data
	local year = year(dofm(`d'))
	local month = month(dofm(`d'))

	* load data
	di _n(2) "Processing" %tm `d' "..."
	use /tmp/allthedata if year == `year' & month == `month', clear

	* run variable generation code
	global date = `d'
	do code/variables/generate_wbhom.do

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
* create a monthly time variable
gen monthdate = ym(year,month)
format %tm monthdate

* examine raw frequencies
tab monthdate wbhom, m

* examine sample-weighted shares
tab monthdate wbhom [aw=basicwgt], m nofreq row
