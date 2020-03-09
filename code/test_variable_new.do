set more off

local beginyear = 1990
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
    append_rawdata, begin(`year') end(`year') sample(march) 
    keep year hfminc hufaminc hefaminc
    do variables/generate_faminc.do
    keep year faminc
    tempfile data`year'
    save `data`year''
}


* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}  
