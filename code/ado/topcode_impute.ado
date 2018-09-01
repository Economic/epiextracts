capture program drop topcode_impute
program define topcode_impute
syntax varname [if] [aweight fweight], generate(name) method(string) topcode(real) [threshold(real 80)]

marksample touse

local method = lower("`method'")
if "`method'" == "pareto" local methodname Pareto

if "`method'" ~= "pareto" {
	noi di "Only Pareto-distribution based imputation is available."
	error 1
}

di _n "Assuming `varlist' has topcode `topcode'"

* Pareto imputation
if "`method'" == "pareto" {
	* threshold check
	if `threshold' < 0 | `threshold' >= 100 {
		noi di "Threshold must be a percentile between 0 and 100"
		error 1
	}

	* grab threshold
	_pctile `varlist' `if' [`weight' `exp'], p(`threshold')
	local thresholdval = r(r1)
	if `thresholdval' == . {
		di "Unable to calculate value of percentile `threshold' for `varlist'"
		error 1
	}

	noi di "Assuming `varlist' should be `methodname' distributed above percentile `threshold' = `thresholdval'"


	local meanabove = 2000

	generate `generate' = `varlist' if `touse'
	replace `generate' = `meanabove' if `touse' & `generate' >= `topcode' & `generate' ~= .

	noi di "Below percentile `threshold', new variable `generate' is equal to `varlist'"
	noi di "Above percentile `threshold', new variable `generate' is equal to `meanabove'"

}

end
