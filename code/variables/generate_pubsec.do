*******************************************************************************
* Public sector
*******************************************************************************
gen byte pubsec = .
if $monthlycps == 0 & $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1981m12) {
		replace pubsec = 0 if class4 >= 1 & class4 ~= .
		replace pubsec = 1 if class4 == 2
	}
}
if $monthlycps == 1 & $maycps == 0 {
	if tm(1976m1) <= $date & $date <= tm(1988m12) {
		replace pubsec = 0 if class >= 1 & class ~= .
		replace pubsec = 1 if class == 2
	}
}
if tm(1989m1) <= $date & $date <= tm(1993m12) {
	replace pubsec = 0 if class >= 1 & class ~= .
	replace pubsec = 1 if 2 <= class & class <= 4
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
	replace pubsec = 0 if peio1cow >= 1 & peio1cow ~= .
	replace pubsec = 1 if 1 <= peio1cow & peio1cow <= 3
}
lab var pubsec "Public sector employee"
lab def pubsec 1 "In public sector" 0 "Not in public sector"
lab val pubsec pubsec
notes pubsec: Different definitions/universes CPS Basic: 1976-1988, 1989-1993, 1994-present
notes pubsec: Different definitions/universes CPS May: 1973-1981
notes pubsec: 1994-present: For first job only
notes pubsec: 1973-1981 Unicon May: class4
notes pubsec: 1976-1993 Unicon Basic: class
notes pubsec: 1994-present CPS: peio1cow
