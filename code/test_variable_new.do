
set more off

local beginyear = 1979
local endyear = 1991

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
    do variables/generate_gradehi.do
    keep year age gradehi asecwgt
    tempfile data`year'
    save `data`year''
}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}

tab gradehi, gen(gradehi_)
* basic CPS does not have age < 14 prior to 1982
drop if age < 14

gcollapse (mean) gradehi_* [pw=asecwgt], by(year)
foreach var of varlist gradehi_* {
    rename `var' march_`var'
}
tempfile marchstats
save `marchstats'

load_epiextracts, begin(`beginyear'm1) end(`endyear'm12) sample(basic) keep(year age gradehi finalwgt basicwgt)
drop if age < 14
tab gradehi, gen(gradehi_)

gcollapse (mean) gradehi_* [pw=finalwgt], by(year)
foreach var of varlist gradehi_* {
    rename `var' basic_`var'
}
merge 1:1 year using `marchstats', assert(3) nogenerate
foreach var in gradehi_1 gradehi_2 gradehi_3 gradehi_4 gradehi_5 gradehi_6 gradehi_7 gradehi_8 gradehi_9 gradehi_10 gradehi_11 gradehi_12 gradehi_13 gradehi_14 gradehi_15 gradehi_16 gradehi_17 gradehi_18 {
    gen diff`var' = basic_`var' - march_`var'
}

sort year
format %4.3f diff*
list year diff*
