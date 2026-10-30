*******************************************************************************
* Health insurance coverage last year: updated processing
*******************************************************************************
* Redesigned questions run through Census's updated processing system.
* Calendar years 2017-present; 2017 comes from the 2018 bridge file and
* overlaps hicovly4.
gen byte hicovly5 = .

if $marchcps == 1 {
	* 2018: bridge-file coverage for the same people, merged on peridnum
	if tm(2018m1) <= $date & $date <= tm(2018m12) {
		replace hicovly5 = 1 if cov_bridge == 1
		replace hicovly5 = 0 if cov_bridge == 2
	}
	if tm(2019m1) <= $date {
		replace hicovly5 = 1 if cov == 1
		replace hicovly5 = 0 if cov == 2
	}
}

lab var hicovly5 "Health insurance coverage last year, updated processing"
lab def hicovly5 1 "Covered" 0 "Not covered"
lab val hicovly5 hicovly5
notes hicovly5: Available 2018-present (calendar years 2017-present)
notes hicovly5: Redesigned questionnaire processed with Census updated system
notes hicovly5: 2018: 2018 CPS ASEC Bridge File coverage merged onto production records; production weights
notes hicovly5: 2018 CPS bridge: cov_bridge
notes hicovly5: 2019-present CPS: cov
