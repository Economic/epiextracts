set more off

local beginyear = 2015
local endyear = 2018

global marchcps = 1
global monthlycps = 0
global maycps = 0
global earnerinfo = 0
global basicfile = 0
adopath ++ ${code}ado

* do the recoding
foreach year of numlist `beginyear' / `endyear' {
    * pull in individual year of raw march CPS
    load_rawcps, begin(`year') end(`year') sample(march)
    *global date = tm(`year'm1) 

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

***************************************************
************** ASEC V. BASIC COMP *****************
***************************************************
use `march_data', clear

* summary stat of ASEC testing variable
gcollapse (mean) schenrl [pw=asecwgt], by(year)
* tag march variables with suffix
foreach var of varlist schenrl {
    rename `var' march_`var'
}

* save march data with tagged variables
tempfile marchstats
save `marchstats'

* load basic data for testing variable
load_epiextracts, begin(`beginyear'm1) end(`endyear'm12) sample(basic) keep(year finalwgt schenrl)
* drop if age < 14 to match march data
drop if age < 14

* summary stat of Basic testing variable
gcollapse (mean) schenrl [pw=finalwgt], by(year)
* tag basic variables with suffix
foreach var of varlist schenrl {
    rename `var' basic_`var'
}

* merge data and calculate difference in ASEC v. Basic testing var rate
merge 1:1 year using `marchstats', assert(3) nogenerate

foreach var in schenrl {
    gen diff`var' = basic_`var' - march_`var'
}

*duplicates tag year hhid personid, gen(tagcount)
*tab year tagcount


