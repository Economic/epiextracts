set more off

local beginyear = 1973
local endyear = 2018

global marchcps = 1
global monthlycps = 0
global maycps = 0
global earnerinfo = 0
global basicfile = 0
adopath ++ ${code}ado

* do the recoding
foreach year of numlist `beginyear' / `endyear' {
    global date = tm(`year'm1)
    load_rawcps, begin(`year') end(`year') sample(march) 
    do variables/generate_asecwgt.do
    do variables/generate_hispanic.do
    do variables/generate_wbho.do
    keep year wbho asecwgt
    tempfile data`year'
    save `data`year''
}


* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}  