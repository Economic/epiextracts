clear all
set more off

/*import delimited using suppdata/state_geocodes
labmask statefips, val(stateabb)
labmask statecensus, val(stateabb)
labmask division, val(divisionname)
labmask region, val(regionname)
drop *name

* start ridiculous hack to add value labels for these variables
* after merging them later in epi_cpsbasic_geog.do
foreach var of varlist statefips statecensus {
	gen `var'_alt = `var'
	lab val `var'_alt `var'
}
keep statefips* statecensus* division* region*
tempfile stategeocodes
save `stategeocodes'
global stategeocodes `stategeocodes'
*/

tempfile rawdat
!unzip -p "/data/cps/march/census/raw/chip2001pub.zip" > `rawdat'
do "code/dictionaries/cpsmar01.do" `rawdat' "code/dictionaries/cpsmar01.dct"
*use `rawdat', clear

/*gen byte statefips = .
replace statefips = gestfips
merge m:1 statefips using $stategeocodes, assert(3) nogenerate

