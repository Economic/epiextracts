set more off

local beginyear = 2015
local endyear = 2018

global marchcps = 1
global monthlycps = 0
global maycps = 0
global earnerinfo = 0
global basicfile = 0
adopath ++ ${code}ado


foreach year of numlist `beginyear' / `endyear' {
    global date = tm(`year'm1)
    load_rawcps, begin(`year') end(`year') sample(march)
    do variables/generate_asecwgt.do
    do variables/generate_hicov.do
    do variables/generate_hiemp.do
    do variables/generate_hipaid.do
    keep year hicov hiemp hipaid asecwgt
    tempfile data`year'
    save `data`year''
}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}

* save temporary file of appended march data with select recoded variables
tempfile march_data
save `march_data'

/*use `march_data', clear

gcollapse (mean) schenrl [pw=asecwgt], by(year)
* tag march variables with suffix
foreach var of varlist schenrl {
    rename `var' march_`var'
}

* save march data with tagged variables
tempfile marchstats
save `marchstats'

* load basic data for faminc variable
load_epiextracts, begin(`beginyear'm1) end(`endyear'm12) sample(basic) keep(year finalwgt schenrl)
* drop if age < 14 to match march data
*drop if age < 14

gcollapse (mean) schenrl [pw=finalwgt], by(year)

foreach var of varlist schenrl {
    rename `var' basic_`var'
}
merge 1:1 year using `marchstats', assert(3) nogenerate

foreach var in schenrl {
    gen diff`var' = basic_`var' - march_`var'
}

*duplicates tag year hhid personid, gen(tagcount)
*tab year tagcount


