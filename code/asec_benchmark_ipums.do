clear
set more off

* import asec data from IPUMS
use /projects/jkandra/epiextracts/suppdata/asec_benchmark.dta, clear

* generate population variable for overall benchmarking
gen pop = 1

* exclude observations where asecwt < 0
*note: asecwt < 0 to account for oversampling (https://forum.ipums.org/t/asecwt-0/2217)
drop if asecwt < 0

* generate rounded weight var
gen rndwgt = round(asecwt, 1)

tempfile main_asec
save `main_asec'

use `main_asec', clear
* calculate overall weighted population counts by year
tab year pop [fw = rndwgt]

xtable year pop [fw = rndwgt], noput
putexcel set "/projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx", sheet(pop_ipums) modify
putexcel A1 = "Population" 
putexcel A2 = matrix(r(xtable)), names 

use `main_asec', clear

* drop years before data is available
keep if year >= 1980

* transform paidgh into indicator var
gen paidgh_dummy = .
replace paidgh_dummy = 0 if paidgh == 10 | paidgh == 0
replace paidgh_dummy = 1 if paidgh == 21 | paidgh == 22 | paidgh == 20

* calculate benchmark share for ~ hiemp
gcollapse (mean) paidgh_dummy [pw = asecwt], by(year) fast

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("hiemp_benchmark") sheetreplace firstrow(variables)

use `main_asec', clear

* drop years before data is available
keep if year >= 1980

* drop observations that are NIU
drop if paidgh == 0

* generate indicator from categorical variable
tab paidgh, gen(paidgh_)

* calculat benchmark share of ~ hipaid
gcollapse (mean) paidgh_* [pw = asecwt], by(year) fast
rename *1 *no
rename *2 *yes
rename *3 *yes_some
rename *4 *yes_all

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("hipaid_benchmark") sheetreplace firstrow(variables)

use `main_asec', clear

* drop years before data is available
keep if year >= 1980

* drop observations that are NIU
drop if pension == 0

* generate indicator from categorical variable
tab pension, gen(pension_)

* calculate benchmark share of ~ penplan
gcollapse (mean) pension_* [pw = asecwt], by(year) fast
rename *1 *no
rename *2 *yes_not_included
rename *3 *yes_included

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("penplan_benchmark") sheetreplace firstrow(variables)

use `main_asec', clear

* drop years before data is available
keep if year >= 1969

* redefine offpov
gen offpov_ = .
replace offpov_ = 1 if offpov == 1 | offpov == 99
replace offpov_ = 0 if offpov == 2

* calculate benchmark share of ~ poverty
gcollapse (mean) offpov_ [pw = asecwt], by(year) fast

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("poverty_benchmark") sheetreplace firstrow(variables)


use `main_asec', clear

* drop years before data is available
keep if year >= 1990

* redefine union variable
*note: exclude NIU
generate _union = .
replace _union = 0 if union == 1
replace _union = 1 if union == 3

* calculate benchmark share of ~ uncov
gcollapse (mean) _union [pw = asecwt], by(year) fast
export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("uncov_benchmark") sheetreplace firstrow(variables)


use `main_asec', clear

* drop years before data is available
keep if year >= 1990

* drop NIU
drop if union == 0

* redefine union variable
*note: exclude NIU
generate _union = .
replace _union = 0 if union == 1
replace _union = 1 if union == 2

* calculate benchmark share of ~ unmem
gcollapse (mean) _union [pw = asecwt], by(year) fast

export excel using /projects/jkandra/epiextracts/suppdata/asec_benchmark.xlsx, sheet("unmem_benchmark") sheetreplace firstrow(variables)
