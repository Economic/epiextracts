local date = `1'
local stategeocodes `2'

*********
* State *
*********
gen byte statefips = .
* some codes in 1976 do not match Unicon documentation
* for now, ensure missing codes for 1976-1977
if tm(1976m1) <= `date' & `date' <= tm(1977m12) {
	drop region
	merge m:1 statefips using `stategeocodes', nogenerate keep(1)

	* ridiculous hack to pull in value labels for statefips
	* which are not merged above
	drop statefips
	rename statefips_alt statefips
}
if tm(1978m1) <= `date' & `date' <= tm(1993m12) {
	drop region statefips
	rename state statecensus

	* invalid state code of 3 in 1985m4
	replace statecensus = . if statecensus == 3 & `date' == tm(1985m4)

	merge m:1 statecensus using `stategeocodes', assert(3) nogenerate
	d state* division* region*

	if `date' >= tm(1989m1) assert statefips == stfips

	* ridiculous hack to pull in value labels for statecensus
	* which are not merged above
	drop statecensus
	rename statecensus_alt statecensus
}
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
