
set more off

* set begin and end local objects
*note: for pulling in data (line 24)
local beginyear = 2015
local endyear = 2018

* set global objects to determine survey type
global marchcps = 1
global monthlycps = 0
global maycps = 0
global earnerinfo = 0
global basicfile = 0

* set `code' object as path to ado files
adopath ++ ${code}ado

* import and save CPI data to adjust wages
sysuse cpi_annual, clear
keep year cpiurs
tempfile cpiurs
save `cpiurs'

* do the recoding
foreach year of numlist `beginyear' / `endyear' {
    * pull in individual year of raw march CPS
    load_rawcps, begin(`year') end(`year') sample(march)
    *global date = tm(`year'm1) 
    * create income and related variables   
    do code/variables/generate_age.do /* age ~ requried variable */
    do code/variables/generate_famwgt.do /* famwgt ~ required for weighting */
    do code/variables/generate_faminc.do
    do code/variables/generate_faminc_c.do
    do code/variables/generate_famid.do /* identify primary families */
    do code/variables/generate_hhtype.do /* identify civilian households */
    do code/variables/generate_hhinc_c.do 

    keep year age faminc_c famwgt famid hhtype hhinc_c

    * save to temporary file
    tempfile data`year'
    save `data`year''
}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    * load beginning year data
    if `year' == `beginyear' use `data`year'', clear
    * append all other years
    else append using `data`year''
}

* save temporary file of appended march data with select recoded variables
tempfile march_data
save `march_data'

* basic CPS does not have age < 14 prior to 1982
drop if age < 14

* merge CPI data
merge m:1 year using `cpiurs'
drop if _merge == 2

* CPI base value
sum cpiurs if year == 2018
local cpi_base = `r(mean)'

* drop missing values (coded as 99999 in raw census)
drop if hhinc_c == 99999 

* create adjusted family income
gen realfaminc = faminc_c * `cpi_base'/cpiurs

* annual median primary family wages in cilivian households
binipolate realfaminc if famid == 1 & hhtype < 9 [pw=famwgt], binsize(0.25) p(50) by(year) collapsefun(gcollapse)
li

* annual mean family wages (unadjusted)
*gcollapse (mean) faminc_c [pw=famwgt], by(year)

* reload clean march data
use `march_data', clear

gen byte faminc_rep = .
replace faminc_rep = 1 if 1 <= faminc & faminc <= 5 /* less than 15000 */
replace faminc_rep = 2 if 6 <= faminc & faminc <= 7 /* 15000-24999 */
replace faminc_rep = 3 if 8 <= faminc & faminc <= 9 /* 25000-34999 */
replace faminc_rep = 4 if 10 <= faminc & faminc <= 11 /* 35000-49999 */
replace faminc_rep = 5 if faminc == 12
replace faminc_rep = 6 if faminc == 13
replace faminc_rep = 7 if faminc == 14
replace faminc_rep = 8 if faminc == 15

* calculate share at each family income band
tab faminc_rep, gen(faminc_rep_)
gcollapse (mean) faminc_rep_* [pw=famwgt], by(year)
li


/*
use `march_data', clear
gcollapse (mean) faminc [pw=famwgt], by(year)
* tag march variables with suffix
foreach var of varlist faminc {
    rename `var' march_`var'
}

* save march data with tagged variables
tempfile marchstats
save `marchstats'

* load basic data for faminc variable
load_epiextracts, begin(`beginyear'm1) end(`endyear'm12) sample(basic) keep(year age faminc finalwgt basicwgt)
* drop if age < 14 to match march data
drop if age < 14
*replace hourslwt = 99 if 99 <= hourslwt 

*tab hourslwt, gen(hourslwt_)

gcollapse (mean) faminc [pw=finalwgt], by(year)
foreach var of varlist faminc {
    rename `var' basic_`var'
}
merge 1:1 year using `marchstats', assert(3) nogenerate
foreach var in faminc_c {
    gen diff`var' = basic_`var' - march_`var'
}

sort year
format %4.3f diff*
list year diff* 

*/

*export excel data.xlsx, firstrow(variables)
