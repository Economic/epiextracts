local date = `1'
local stategeocodes `2'

****************
* State - FIPS *
****************
gen byte statefips = .
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace statefips = gestfips

	merge m:1 statefips using `stategeocodes', assert(3) nogenerate

	if `date' <= tm(2013m12) assert statecensus == gestcen
	assert region == gereg

	* ridiculous hack to pull in value labels for statefips
	* which are not merged above
	drop statefips
	rename statefips_alt statefips
}

lab var statefips "State - FIPS code"
notes statefips: CPS: gestfips

lab var statecensus "State - Census code"
notes statecensus: derived from statefips

lab var division "Census division (1-9)"
notes division: derived from statefips

lab var region "Census region (1-4)"
notes region: derived from statefips
