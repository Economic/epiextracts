
set more off

local beginyear = 2015
local endyear = 2018

global marchcps = 1
global monthlycps = 0
global maycps = 0
global earnerinfo = 0
global basicfile = 0
adopath ++ ${code}ado

sysuse cpi_annual, clear
keep year cpiurs
tempfile cpiurs
save `cpiurs'

* do the recoding
foreach year of numlist `beginyear' / `endyear' {
    load_rawcps, begin(`year') end(`year') sample(march)
    global date = tm(`year'm1)    
    do code/variables/generate_age.do
    do code/variables/generate_famwgt.do
    do code/variables/generate_faminc_c.do
    do code/variables/generate_famid.do
    keep year age faminc_c famwgt famid
    tempfile data`year'
    save `data`year''
}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}


*tab realfaminc, gen(realfaminc_)

*tab hourslwt, gen(hourslwt_)
* basic CPS does not have age < 14 prior to 1982
drop if age < 14

merge m:1 year using `cpiurs'
drop if _merge == 2

sum cpiurs if year == 2018
local cpi_base = `r(mean)'

gen realfaminc = faminc_c * `cpi_base'/cpiurs

binipolate faminc_c if famid == 1 [pw=famwgt], binsize(0.25) p(50) by(year) collapsefun(gcollapse)
li

*gcollapse (mean) faminc_c [pw=famwgt], by(year)




/*foreach var of varlist faminc_c {
    rename `var' march_`var'
}
tempfile marchstats
save `marchstats'

load_epiextracts, begin(`beginyear'm1) end(`endyear'm12) sample(basic) keep(year age faminc_c finalwgt basicwgt)
drop if age < 14
*replace hourslwt = 99 if 99 <= hourslwt 

*tab hourslwt, gen(hourslwt_)

gcollapse (mean) faminc_c [pw=finalwgt], by(year)
foreach var of varlist faminc_c {
    rename `var' basic_`var'
}
merge 1:1 year using `marchstats', assert(3) nogenerate
foreach var in faminc_c {
    gen diff`var' = basic_`var' - march_`var'
}

sort year
format %4.3f diff*
*list year diff* */

*export excel data.xlsx, firstrow(variables)
