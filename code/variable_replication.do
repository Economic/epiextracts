set more off

local beginyear = 1988
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
    do code/variables/generate_asecwgt.do
    do code/variables/generate_selfinc.do
    keep year asecwgt selfinc
    tempfile data`year'
    save `data`year''
}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}

*keep if famtype == 1
*gcollapse (mean) faminc_c [pw=famwgt], by(year)

*duplicates tag year hhid personid, gen(tagcount)
*tab year tagcount



/*
* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}  

* median family income by year
binipolate faminc_c if famid == 1 [pw=famwgt], binsize(0.25) p(50) by(year) collapsefun(gcollapse)
li




*gen byte faminc_rep = .
replace faminc_rep = 1 if 1 <= faminc & faminc <= 5
replace faminc_rep = 2 if 6 <= faminc & faminc <= 7
replace faminc_rep = 3 if 8 <= faminc & faminc <= 9
replace faminc_rep = 4 if 10 <= faminc & faminc <= 11
replace faminc_rep = 5 if faminc == 12
replace faminc_rep = 6 if faminc == 13
replace faminc_rep = 7 if faminc == 14
replace faminc_rep = 8 if faminc == 15

tab faminc_rep, gen(faminc_rep_)
gcollapse (mean) faminc_rep_* [pw=famwgt], by(year)
li

*export excel data.xlsx, firstrow(variables)
*/
