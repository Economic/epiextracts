local date = `1'

****************************
* BASIC SAMPLE RESTRICTION *
****************************
* only include adults with labor force status, 16+
if tm(1976m1) <= `date' & `date' <= tm(1993m12) {
	keep if mlr >= 1 & mlr <= 7 & age >= 16 & age != .
}
if tm(1994m1) <= `date' & `date' <= tm(2012m4) {
	* it should be the case that pemlr is only defined iff prpertyp = 2
	* exceptions in 2005m1
	if `date' == tm(2005m1) {
		* 15 children (prpertyp=1) with pemlr=nilf-other
		gen problem_prpertyp = pemlr >=1 & pemlr <= 7 & prpertyp == 1
		count if problem_prpertyp == 1
		assert r(N) == 15

		* 94 adult civ (prpertyp=2) with missing pemlr
		gen problem_pemlr = pemlr == -1 & prpertyp == 2
		count if problem_pemlr == 1
		assert r(N) == 94

		assert prpertyp == 2 if pemlr >= 1 & pemlr <= 7 & problem_prpertyp == 0
		assert pemlr >= 1 & pemlr <= 7 if prpertyp == 2 & problem_pemlr == 0
	}
	else {
		assert prpertyp == 2 if pemlr >= 1 & pemlr <= 7
		assert pemlr >= 1 & pemlr <= 7 if prpertyp == 2
	}
	assert (pemlr >= 1 & pemlr <= 7) | pemlr == -1
	keep if pemlr >= 1 & pemlr <= 7 & peage >= 16 & peage != .
}
