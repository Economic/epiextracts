********************************************************************************
* statefips
********************************************************************************
gen byte statefips = .

if $marchcps == 1 {

	if tm(1962m1) <= $date & $date <= tm(1962m12) {
		* no state geography released in 1962; state is entirely missing
		* we want the missing values and the full value labels, so do the following merge
		cap drop region
		merge m:1 statefips using $stategeocodes, keep(1) nogenerate
		* ridiculous hack to pull in value labels for statefips
		* which are not merged above
		drop statefips
		rename statefips_alt statefips
	}

	if tm(1963m1) <= $date & $date <= tm(1967m12) {
		* unique era-specific unicon state code scheme (label: fstate)
		* not modern FIPS and not the standard 1960 census code used from 1977 onward
		replace statefips = state
		recode statefips (0=.) (1=23) (2=25) (3=33) (4=50) (5=44) (6=9) ///
			(10=36) (11=34) (13=42) (22=55) (23=18) (24=39) (25=17) (26=26) ///
			(31=27) (32=19) (33=29) (34=38) (35=46) (36=31) (37=20) ///
			(41=10) (42=24) (43=11) (44=51) (45=54) (46=45) (47=37) (48=13) (49=12) ///
			(51=21) (52=47) (53=1) (54=28) ///
			(65=5) (66=22) (67=40) (68=48) ///
			(71=30) (72=16) (73=56) (74=8) (75=35) (76=4) (77=49) (78=32) ///
			(85=2) (86=15) (87=53) (88=41) (89=6)
		cap drop region
		* not all real state/DC or group codes will be used every era, so
		* tolerate (and discard) unmatched using rows; a genuinely unmatched
		* master row (an uncovered raw code) should still fail loudly
		merge m:1 statefips using $stategeocodes, assert(2 3) keep(3) nogenerate
		* ridiculous hack to pull in value labels for statefips
		* which are not merged above
		drop statefips
		rename statefips_alt statefips
	}

	if tm(1968m1) <= $date & $date <= tm(1972m12) {
		* unicon state recode: disclosure-suppressed grouping scheme #1 (era B1)
		* individually-identified states map to modern FIPS; grouped codes map to
		* the group codes defined in suppdata/state_geocodes.csv (101-111)
		replace statefips = state
		recode statefips (0=.) ///
			(11=9) (21=36) (22=34) (23=42) (31=39) (32=18) (33=17) (43=29) ///
			(51=11) (52=24) (53=54) (54=13) (55=12) (61=21) (62=47) (71=22) ///
			(72=48) (91=41) (92=6) ///
			(19=101) (39=102) (41=103) (49=104) (57=105) (59=106) (69=107) ///
			(79=108) (81=109) (89=110) (99=111)
		cap drop region
		merge m:1 statefips using $stategeocodes, assert(2 3) keep(3) nogenerate
		* ridiculous hack to pull in value labels for statefips
		* which are not merged above
		drop statefips
		rename statefips_alt statefips
	}

	if tm(1973m1) <= $date & $date <= tm(1976m12) {
		* unicon state recode: disclosure-suppressed grouping scheme #2 (era B2)
		* individually-identified states map to modern FIPS; grouped codes map to
		* the group codes defined in suppdata/state_geocodes.csv (102, 107, 112-119)
		replace statefips = state
		recode statefips (0=.) ///
			(14=25) (16=9) (21=36) (22=34) (23=42) (31=39) (32=18) (33=17) ///
			(53=11) (56=37) (59=12) (72=48) (92=6) ///
			(19=112) (39=102) (49=113) (57=114) (58=115) (67=116) (69=107) ///
			(79=117) (89=118) (99=119)
		cap drop region
		merge m:1 statefips using $stategeocodes, assert(2 3) keep(3) nogenerate
		* ridiculous hack to pull in value labels for statefips
		* which are not merged above
		drop statefips
		rename statefips_alt statefips
	}
	if tm(1977m1) <= $date & $date <= tm(1997m12) {
		drop region statefips
		rename state statecensus
		merge m:1 statecensus using $stategeocodes, assert(2 3) keep(3) nogenerate
		drop statecensus
		rename statecensus_alt statecensus
	}

	if tm(1998m1) <= $date & $date <= tm(2000m12) {
		drop region statefips
		rename hg_st60 statecensus
		* we want the missing values and the full value labels, so do the following merge
		merge m:1 statecensus using $stategeocodes, assert(2 3) keep(3) nogenerate
		cap rename hg_reg gereg
		assert region == gereg
		* ridiculous hack to pull in value labels for statefips
		* which are not merged above
		drop statecensus
		rename statecensus_alt statecensus
	}

	if tm(2001m1) <= $date {
		replace statefips = gestfips
		* we want the missing values and the full value labels, so do the following merge
		merge m:1 statefips using $stategeocodes, assert(2 3) keep(3) nogenerate
		cap rename hg_reg gereg
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
		* not all real state or group codes will be used every era, so
		* tolerate (and discard) unmatched using rows (_merge==2); a genuinely
		* unmatched master row (an uncovered raw code) should still fail loudly
		if $date == tm(1985m4) {
			assert inlist(_merge, 2, 3) if statecensus != 3
			replace statecensus = . if statecensus == 3
		}
		else assert inlist(_merge, 2, 3)
		drop if _merge == 2
		drop _merge

		if $date >= tm(1989m1) assert statefips == stfips

		* ridiculous hack to pull in value labels for statecensus
		* which are not merged above
		drop statecensus
		rename statecensus_alt statecensus
	}
	if tm(1994m1) <= $date {
		replace statefips = gestfips
		merge m:1 statefips using $stategeocodes, assert(2 3) keep(3) nogenerate
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
