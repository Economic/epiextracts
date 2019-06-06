********************************************************************************
* Basic monthly weight
********************************************************************************
gen marchwgt = .

if $marchcps == 1 {
	if tm(1998m1) <= $date {
		replace marchwgt = marsupwt
	}
}

lab var marchwgt "March supplement person weight"
notes marchwgt: Supplemental final weight
notes marchwgt: 1998-present March: marsupwt
