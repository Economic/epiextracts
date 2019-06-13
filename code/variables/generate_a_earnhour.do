********************************************************************************
* a_earnhour
* Hourly earnings, for those paid by the hour
* EXcludes overtime, tips, commissions
********************************************************************************
gen a_earnhour = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1979m1) <= $date & $date <= tm(1988m12) {
			replace a_earnhour = 0 if earnhour > 0 & earnhour ~= .
			replace a_earnhour = 1 if aernhr == 1 & earnhour > 0 & earnhour ~= .
			assert a_earnhour ~= . if earnhour > 0 & earnhour ~= .
		}
		if tm(1989m1) <= $date & $date <= tm(1993m12) {
			replace a_earnhour = 0 if earnhour > 0 & earnhour ~= .
			replace a_earnhour = 1 if aernhr >= 1 & aernhr <= 8 & earnhour > 0 & earnhour ~= .
			replace a_earnhour = 1 if ernhr ~= ernhrx & earnhour > 0 & earnhour ~= .
			assert a_earnhour ~= . if earnhour > 0 & earnhour ~= .
		}
		if tm(1995m9) <= $date {
			replace a_earnhour = 0 if earnhour > 0 & earnhour ~= .
			replace a_earnhour = 1 if prhernal == 1 & earnhour > 0 & earnhour ~= .
			assert a_earnhour ~= . if earnhour > 0 & earnhour ~= .
		}
	}
}

lab var a_earnhour "Hourly earnings allocated by BLS"
lab def a_earnhour 0 "Not allocated" 1 "Allocated"
lab val a_earnhour a_earnhour
notes a_earnhour: Allocation coding inconsistent across time
notes a_earnhour: No allocation codes available during 1994m1-1995m8
