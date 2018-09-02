capture program drop topcode_impute
program define topcode_impute, rclass
syntax varname [if] [pweight], generate(name) method(string) topcodeval(real) [threshold(real 80)]

marksample touse

local method = lower("`method'")
if "`method'" == "pareto" local methodname Pareto

if "`method'" ~= "pareto" {
	noi di "Only Pareto-distribution based imputation is available."
	error 1
}

di _n "Assume `varlist' has topcode = `topcodeval'"

* Pareto imputation
noi if "`method'" == "pareto" {
	* threshold check
	if `threshold' < 0 | `threshold' >= 100 {
		noi di "Threshold must be a percentile between 0 and 100"
		error 1
	}
	* need non-missing values of `varlist' for this to make sense
	capture assert `varlist' ~= . `if'
	if _rc ~= 0 {
		noi di "`varlist' needs to be nonmissing `if'"
		error 1
	}

	* grab treshold percentile
	if "`weight'" ~= "" _pctile `varlist' `if' [aw `exp'], p(`threshold')
	if "`weight'" == "" _pctile `varlist' `if', p(`threshold')
	local thresholdval = r(r1)
	if `thresholdval' == . {
		noi di "Unable to calculate value of percentile `threshold' for `varlist'"
		error 1
	}
	if `thresholdval' <= 0 {
		noi di "Percentile `threshold' value of `varlist' needs to be positive"
		error 1
	}

	preserve

	keep if `touse'
	tempvar n bin running
	replace `varlist' = `topcodeval' if `varlist' >= `topcodeval'
	gen `bin' = round((`varlist' / 50))*50
	gen `n' = 1
	collapse (sum) `n' [`weight' `exp'], by(`bin')
	gsort -`bin'
	gen `running' = sum(`n')

	* restrict to wage distribution above percentile threshold
	keep if `bin' >= round(`thresholdval' * 50) / 50

	* estimate shape parameter
	tempvar logrunning logbin
	gen `logrunning' = log(`running')
	gen `logbin' = log(`bin')
	reg `logrunning' `logbin'
	local alpha = -_b[`logbin']
	local newmeanabove = `topcodeval' * `alpha' / (`alpha' - 1)

	restore

	noi di "Assume `varlist' should be `methodname' distributed above percentile `threshold', i.e., `varlist' = " %6.2f `thresholdval'

	generate `generate' = `varlist' if `touse'
	replace `generate' = `newmeanabove' if `touse' & `generate' >= `topcodeval' & `generate' ~= .

	noi di "Below topcode `topcodeval', new variable `generate' = `varlist'"
	noi di "Above topcode `topcodeval', new variable `generate' = " %6.2f `newmeanabove'

	noi di "Ratio of new mean above to old top-code = " %4.2f `newmeanabove' / `topcodeval'

	return scalar topcodeval = `topcodeval'
	return scalar newmeanabove = `newmeanabove'

}

end
