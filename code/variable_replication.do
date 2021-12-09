set more off

local beginyear = 1986
local endyear = 1990

global marchcps = 1
global monthlycps = 0
global maycps = 0
global earnerinfo = 0
global basicfile = 0
adopath ++ ${code}ado


foreach year of numlist `beginyear' / `endyear' {
    global date = tm(`year'm1)
    load_rawcps, begin(`year') end(`year') sample(march)
    do code/variables/generate_age.do
    do code/variables/generate_asecwgt.do
    do code/variables/generate_selfemp.do
    keep year asecwgt age selfemp
    tempfile data`year'
    save `data`year''
}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}

tab year selfemp
