********************************************************************************
* Household weight
********************************************************************************
capture rename hhwgt oldhhwgt
gen hhwgt = .

if $monthlycps == 1 {
	if tm(1989m1) <= $date & $date <= tm(1993m12) {
		replace hhwgt = oldhhwgt / 100
	}
	if tm(1994m1) <= $date {
		replace hhwgt = hwhhwgt / 10000
	}
}

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1976m12) {

		* weight of primary householder
        bysort hserial: egen hhwgt_primhh = max(cond(_relhd == 1, asecwgt, .))

        replace hhwgt = hhwgt_primhh

	}
	if tm(1968m1) <= $date & $date <= tm(1975m12) {
		* ~600 households per year have no _relhd == 1 record (head coded as
		* NIU or spouse); fall back to the household head identified by hhrel
		bysort hserial: egen hhwgt_hhrel = max(cond(hhrel == 1, asecwgt, .))
		replace hhwgt = hhwgt_hhrel if missing(hhwgt)
		drop hhwgt_hhrel
	}
	if tm(1977m1) <= $date & $date <= tm(1997m12) {
		replace hhwgt = oldhhwgt / 100
	}

	if tm(1998m1) <= $date & $date <= tm(2013m12) {
		replace hhwgt = hsup_wgt if hsup_wgt > 0
	}
	if tm(2014m1) <= $date & $date <= tm(2014m12) {
		replace hhwgt = hsup_wgt * (3/8) if redesign == 1
		replace hhwgt = hsup_wgt * (5/8) if redesign == 0
	}
	if tm(2015m1) <= $date & $date <= tm(2018m12) {
		replace hhwgt = hsup_wgt
	}
	if tm(2019m1) <= $date {
		replace hhwgt = hsup_wgt / 100
	}

	* population controls used in Census's published series (see asecwgt)
	if tm(1980m1) <= $date & $date <= tm(1980m12) {
		* household head's alternate weight
		bysort hserial: egen hhwgt_head = max(cond(_relhd == 1, asecwgt, .))
		replace hhwgt = hhwgt_head
		drop hhwgt_head
	}
	if tm(1993m1) <= $date & $date <= tm(1993m12) {
		replace hhwgt = hhwgtalt / 100
	}
	if inlist(year(dofm($date)), 2011, 2021, 2025) {
		* reference person's revised weight (reproduces hsup_wgt exactly in other years)
		bysort hserial: egen hhwgt_refper = max(cond(inlist(a_exprrp, 1, 2), asecwgt, .))
		replace hhwgt = hhwgt_refper
		drop hhwgt_refper
	}

	* group quarters units are not households in Census household tabulations;
	* flag them by year-specific source variable and set weight to missing
	gen byte hhwgt_gq = 0
	if tm(1962m1) <= $date & $date <= tm(1962m12) {
		bysort hserial: egen hhwgt_gqany = max(lvqtyp == 1)
		replace hhwgt_gq = hhwgt_gqany
		drop hhwgt_gqany
	}
	if tm(1963m1) <= $date & $date <= tm(1975m12) {
		* note: 1963 value labels are shifted, but code 2 is group quarters in all years
		bysort hserial: egen hhwgt_gqany = max(lvqtyp == 2)
		replace hhwgt_gq = hhwgt_gqany
		drop hhwgt_gqany
	}
	if tm(1976m1) <= $date & $date <= tm(1987m12) {
		replace hhwgt_gq = 1 if htype2 == 2
	}
	if tm(1988m1) <= $date {
		* EPI hhtype (generated earlier): 9-10 are group quarters
		replace hhwgt_gq = 1 if inlist(hhtype, 9, 10)
	}
	replace hhwgt = . if hhwgt_gq == 1
	drop hhwgt_gq
}

lab var hhwgt "Household weight"
notes hhwgt: Household weight, based on head of household
notes hhwgt: 1989-1993 Unicon Basic: hhwgt
notes hhwgt: 1994-present CPS Basic: hwhhwgt
notes hhwgt: 1962-1976: Unicon March: asecwgt of household head (_relhd)
notes hhwgt: 1968-1975: Unicon March: falls back to asecwgt of hhrel head if no _relhd head
notes hhwgt: 1977-1997: Unicon March: hhwgt
notes hhwgt: 1998-present: CPS March: hsup_wgt
notes hhwgt: March population controls match Census's published historical income tables (see asecwgt)
notes hhwgt: 1980: head's asecwgt (wgtalt); 1993: hhwgtalt; 2011, 2021, 2025: reference person's revised asecwgt
notes hhwgt: March: missing for group quarters units (lvqtyp 1962-1975, htype2 1976-1987, hhtype 1988-present)
