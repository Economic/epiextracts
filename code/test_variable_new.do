set more off

local beginyear = 1979
local endyear = 2018

global marchcps = 1
global monthlycps = 0
global maycps = 0
global earnerinfo = 0
global basicfile = 0
adopath ++ ${code}ado

* do the recoding
foreach year of numlist `beginyear' / `endyear' {
    load_rawcps, begin(`year') end(`year') sample(march)
    global date = tm(`year'm1)    
    do variables/generate_age.do
    do variables/generate_asecwgt.do
    do variables/generate_faminc.do
    keep year age faminc asecwgt
    tempfile data`year'
    save `data`year''
}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}

tab faminc, gen(faminc_)
* basic CPS does not have age < 14 prior to 1982
drop if age < 14 & year <= 1981

gcollapse (mean) faminc_* [pw=asecwgt], by(year)
foreach var of varlist faminc_* {
    rename `var' march_`var'
}
tempfile marchstats
save `marchstats'

load_epiextracts, begin(`beginyear'm1) end(`endyear'm12) sample(basic) keep(year age faminc finalwgt basicwgt)
tab faminc, gen(faminc_)
gcollapse (mean) faminc_* [pw=finalwgt], by(year)
foreach var of varlist faminc_* {
    rename `var' basic_`var'
}
merge 1:1 year using `marchstats', assert(3) nogenerate
foreach var in faminc_1 faminc_2 faminc_3 faminc_4 faminc_5 faminc_6 faminc_7 faminc_8 faminc_9 faminc_10 faminc_ 11 faminc_12 faminc_13 faminc_14 faminc_15 {
    gen diff`var' = basic_`var' - march_`var'
}

sort year
format %4.3f diff*
list year diff*
