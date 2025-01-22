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

if $marchcps == 1 {
	if tm(1976m1) <= $date & $date <= tm(1997m12) {
		replace a_earnhour = 0 if earnhour > 0 & earnhour ~= .
		replace a_earnhour = 1 if ahours == 1 & earnhour > 0 & earnhour ~= .
		assert a_earnhour ~= . if earnhour > 0 & earnhour ~= .		
	}
	if tm(1998m1) <= $date & $date <= tm(2006m12) {
		replace a_earnhour = 0 if earnhour > 0 & earnhour ~= .
		replace a_earnhour = 1 if aphrs == 1 & earnhour > 0 & earnhour ~= .
		assert a_earnhour ~= . if earnhour > 0 & earnhour ~= .
	}	
	if tm(2007m1) <= $date & $date <= tm(2010m12) {
		replace a_earnhour = 0 if earnhour > 0 & earnhour ~= .
		replace a_earnhour = 1 if a1hrs == 1 & earnhour > 0 & earnhour ~= .
		assert a_earnhour ~= . if earnhour > 0 & earnhour ~= .
	}
	if tm(2011m1) <= $date {
		replace a_earnhour = 0 if earnhour > 0 & earnhour ~= .
		replace a_earnhour = 1 if axhrs == 1 & earnhour > 0 & earnhour ~= .
		assert a_earnhour ~= . if earnhour > 0 & earnhour ~= .
	}
}

lab var a_earnhour "Hourly earnings allocated by BLS"
lab def a_earnhour 0 "Not allocated" 1 "Allocated"
lab val a_earnhour a_earnhour
notes a_earnhour: Allocation coding inconsistent across time
notes a_earnhour: Basic: No allocation codes available during 1994m1-1995m8
