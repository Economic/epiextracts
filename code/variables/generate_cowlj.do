*******************************************************************************
* Detailed class of worker, longest job last year
*******************************************************************************
gen byte cowly = .

if $marchcps == 1 {
	if tm(1962m1) <= $date & $date <= tm(1962m12) {
		replace cowly = 1 if clslyr == 0
		replace cowly = 8 if clslyr == 1
		replace cowly = 6 if clslyr == 2
		replace cowly = 7 if clslyr == 3
	}
	if tm(1963m1) <= $date & $date <= tm(1975m12) {
		replace cowly = 1 if clslyr == 1
		replace cowly = 8 if clslyr == 2
		replace cowly = 6 if clslyr == 3
		replace cowly = 7 if clslyr == 4
	}
	if tm(1976m1) <= $date & $date <= tm(1997m12) {
		replace cowly = clslyr if clslyr > 0
	}
	if tm(1998m1) <= $date {
		replace cowly = ljcw if ljcw > 0
	}
}

lab var cowly "Class of Worker, longest job last year"
#delimit ;
lab def cowly
1 "Private"
2 "Government - Federal"
3 "Government - State"
4 "Government - Local"
5 "Self-employed, incorporated"
6 "Self-employed, unincorporated"
7 "Without pay"
8 "Government"
;
#delimit cr
lab val cowly cowly
notes cowly: 1962-1975: Self-employed, incorporated included in Private
notes cowly: 1962-1997 Unicon March: clslyr
notes cowly: 1998-present CPS March: ljcw