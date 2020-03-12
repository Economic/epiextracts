
set more off

local beginyear = 1989
local endyear = 1989

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
    do variables/generate_married.do
    keep year age married asecwgt
    tempfile data`year'
    save `data`year''
}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}

tab married, gen(married_)
* basic CPS does not have age < 14 prior to 1982
drop if age < 14 & year <= 1981
keep if age >= 15

gcollapse (mean) married_* [pw=asecwgt], by(year)
foreach var of varlist married_* {
    rename `var' march_`var'
}
tempfile marchstats
save `marchstats'

load_epiextracts, begin(`beginyear'm1) end(`endyear'm12) sample(basic) keep(year age married finalwgt basicwgt)
tab married, gen(married_)
keep if age >= 15

gcollapse (mean) married_* [pw=finalwgt], by(year)
foreach var of varlist married_* {
    rename `var' basic_`var'
}
merge 1:1 year using `marchstats', assert(3) nogenerate
foreach var in married_1 married_2 {
    gen diff`var' = basic_`var' - march_`var'
}

sort year
format %4.3f diff*
list year diff*
