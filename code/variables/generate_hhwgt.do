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
        bysort _hhid: egen hhwgt_primhh = max(cond(_relhd == 1, asecwgt, .))

        replace hhwgt = hhwgt_primhh

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
}

lab var hhwgt "Household weight"
notes hhwgt: Household weight, based on head of household
notes hhwgt: 1989-1993 Unicon Basic: hhwgt
notes hhwgt: 1994-present CPS Basic: hwhhwgt
notes hhwgt: 1977-1997: Unicon March: hhwgt
notes hhwgt: 1998-present: CPS March: hsup_wgt
