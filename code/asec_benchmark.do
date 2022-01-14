clear
set more off

* set time frame
local beginyear = 1962
local endyear = 2018

* set global macros for the ado files to work properly
global marchcps = 1
global monthlycps = 0
global maycps = 0
global earnerinfo = 0
global basicfile = 0
adopath ++ ${code}ado

* run through variables being tested and save as tempfiles
foreach year of numlist `beginyear' / `endyear' {
    global date = tm(`year'm1) 
    load_rawcps, begin(`year') end(`year') sample(march)
    do variables/generate_asecwgt.do
    do variables/generate_hiemp.do
    do variables/generate_hipaid.do
    do variables/generate_penplan.do
    do variables/generate_poverty.do
    do variables/generate_uncov.do
    do variables/generate_unmem.do
    keep year asecwgt hiemp hipaid penplan poverty uncov unmem
    tempfile data`year'
    save `data`year''

}

* load the data back into memory
foreach year of numlist `beginyear' / `endyear' {
    if `year' == `beginyear' use `data`year'', clear
    else append using `data`year''
}

* generate population variable for overall benchmarking
gen pop = 1

* exclude observations where asecwt < 0
*note: asecwt < 0 to account for oversampling (https://forum.ipums.org/t/asecwt-0/2217)
drop if asecwgt < 0

* generate rounded weight var
gen rndwgt = round(asecwgt, 1)

tempfile main_asec
save `main_asec'

/*use `main_asec', clear
* calculate overall weighted population counts by year
tab year pop [fw = rndwgt]

xtable year pop [fw = rndwgt], noput
putexcel set "/projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx", sheet(pop) modify
putexcel A1 = "Population" 
putexcel A2 = matrix(r(xtable)), names 

use `main_asec', clear

* drop years before data is available
keep if year >= 1980

* calculate benchmark share for ~ hiemp
gcollapse (mean) hiemp [pw = asecwgt], by(year) fast

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("hiemp") sheetreplace firstrow(variables)

/*use `main_asec', clear

* drop years before data is available
keep if year >= 1980

* generate indicator from categorical variable
tab hipaid, gen(hipaid_)

* calculat benchmark share of ~ hipaid
gcollapse (mean) hipaid_* [pw = asecwgt], by(year) fast
rename *1 *no
rename *2 *yes_some
rename *3 *yes_all

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("hipaid") sheetreplace firstrow(variables)

use `main_asec', clear

* drop years before data is available
keep if year >= 1980

* generate indicator from categorical variable
tab penplan, gen(penplan_)

* calculate benchmark share of ~ penplan
gcollapse (mean) penplan_* [pw = asecwgt], by(year) fast
rename *1 *no
rename *2 *yes_not_included
rename *3 *yes_included

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("penplan") sheetreplace firstrow(variables)

use `main_asec', clear

* drop years before data is available
keep if year >= 1969

* calculate share of poverty
gcollapse (mean) poverty [pw = asecwgt], by(year) fast

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("poverty") sheetreplace firstrow(variables)


use `main_asec', clear

* drop years before data is available
keep if year >= 1990


* calculate share of uncov
gcollapse (mean) uncov [pw = asecwgt], by(year) fast
export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("uncov") sheetreplace firstrow(variables)


use `main_asec', clear

* drop years before data is available
keep if year >= 1990

* calculate share of unmem
gcollapse (mean) unmem [pw = asecwgt], by(year) fast

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("unmem") sheetreplace firstrow(variables)
*/


