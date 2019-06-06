********************************************************************************
* statefips
********************************************************************************
gen byte statefips = .

if $marchcps == 1 {
	if tm(1998m1) <= $date {
		replace statefips = gestfips
		* we want the missing values and the full value labels, so do the following merge
		merge m:1 statefips using $stategeocodes, assert(3) nogenerate
		assert region == gereg
		* ridiculous hack to pull in value labels for statefips
		* which are not merged above
		drop statefips
		rename statefips_alt statefips
	}
}

if $monthlycps == 1 | $maycps == 1 {
	* some codes in 1976 do not match Unicon documentation
	* for now, ensure missing codes for 1976-1977
	if tm(1973m1) <= $date & $date <= tm(1977m12) {
		drop region
		* even though all state (and other geographic) codes will be missing
		* we want the missing values and the full value labels, so do the following merge
		merge m:1 statefips using $stategeocodes, nogenerate keep(1)
		* ridiculous hack to pull in value labels for statefips
		* which are not merged above
		drop statefips
		rename statefips_alt statefips
	}
	if tm(1978m1) <= $date & $date <= tm(1993m12) {
		drop region statefips
		rename state statecensus

		merge m:1 statecensus using $stategeocodes

		* deal with invalid state codes
		* invalid state census code = 3 in 1985m4
		if $date == tm(1985m4) {
			assert _merge == 3 if statecensus != 3
			replace statecensus = . if statecensus == 3
		}
		else assert _merge == 3
		drop _merge

		if $date >= tm(1989m1) assert statefips == stfips

		* ridiculous hack to pull in value labels for statecensus
		* which are not merged above
		drop statecensus
		rename statecensus_alt statecensus
	}
	if tm(1994m1) <= $date {
		replace statefips = gestfips
		merge m:1 statefips using $stategeocodes, assert(3) nogenerate
		if $date <= tm(2013m12) assert statecensus == gestcen
		assert region == gereg

		* ridiculous hack to pull in value labels for statefips
		* which are not merged above
		drop statefips
		rename statefips_alt statefips
	}
}

lab var statefips "State - FIPS code"
notes statefips: 1978-1993, derived from Unicon state census code: state
notes statefips: 1994-present, CPS: gestfips
