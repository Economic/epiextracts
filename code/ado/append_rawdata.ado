*************************************************************************
* NAME: append_rawdata
* DESC: Append raw source data in hard-coded paths and load into memory.
* Useful for analysis/testing. Not used in the creation of extracts.
*************************************************************************
capture program drop append_rawdata
program define append_rawdata
syntax, begin(integer) end(integer) sample(string) [keeponly(string)]

* determine sample
local lowersample = lower("`sample'")
if "`lowersample'" == "org" local samplename ORG
else if "`lowersample'" == "basic" local samplename Basic
else if "`lowersample'" == "may" local samplename May
else {
	di _n "You must specify Basic or ORG or May sample."
	error 1
}
di _n "Working on CPS `samplename' from `begin' to `end'..." _n

foreach year of numlist `begin'(1)`end' {
	* file paths
	if "`lowersample'" == "may" {
		local inputpath /data/cps/may/unicon/
	}
	else if "`lowersample'" == "org" & `year' >= 1979 & `year' <= 1983 {
		local inputpath /data/cps/org/unicon/
	}
	else if "`lowersample'" == "org" & `year' >= 1984 & `year' <= 1993 {
		local inputpath /data/cps/basic/unicon/
	}
	else if "`lowersample'" == "basic" & `year' <= 1993 {
		local inputpath /data/cps/basic/unicon/
	}
	else if ("`lowersample'" == "basic" | "`lowersample'" == "org") & `year' >= 1994 {
		local inputpath /data/cps/basic/census/stata/
	}
	else {
		di "Sample and years combination not valid"
		error 1
	}

	* determine whether annual or monthly sample
	if "`lowersample'" == "may" local annualsample = 1
	else local annualsample = 0

	* create keep statement for ORG subsamples
	if "`lowersample'" == "org" {
		if `year' >= 1979 & `year' <= 1993 local keeponlyorg keep if (mis == 4 | mis == 8) & ernwgt > 0 & ernwgt ~= .
		if `year' >= 1994 local keeponlyorg keep if (hrmis == 4 | hrmis == 8) & pworwgt > 0 & pworwgt ~= .
	}
	else local keeponlyorg ""

	* Load each annual file
	if `annualsample' == 1 {
		if "`lowersample'" == "may" local inputfile unicon_may_`year'.dta
		else {
			di "Something is wrong with your intended sample"
			error 1
		}
		qui {
			unzipfile `inputpath'`inputfile'.zip, replace
			use `inputfile', clear
			if "`keeponly'" ~= "" {
				keepifexist `keeponly'
				local keeplist "`r(keeplist)'"
			}
			else local keeplist "_all"
			cap drop year
			gen int year = `year'
			noi di "Loading CPS `samplename', `year': `keeplist'"
			tempfile annualdata`year'
			save `annualdata`year''
			erase `inputfile'
		}

	}

	* Local each monthly file and create annual file
	if `annualsample' == 0 {
		forvalues month = 1/12 {
			if "`lowersample'" == "org" & `year' <= 1983 {
				local inputfile unicon_org_`year'_`month'.dta
			}
			else if ("`lowersample'" == "basic" | "`lowersample'" == "org") & `year' <= 1993 {
				local inputfile unicon_basic_`year'_`month'.dta
			}
			else if ("`lowersample'" == "basic" | "`lowersample'" == "org") & `year' >= 1994 {
				local inputfile cps_`year'_`month'.dta
			}
			qui {
				unzipfile `inputpath'`inputfile'.zip, replace
				use `inputfile', clear
				if "`lowersample'" == "org" {
					`keeponlyorg'
				}
				if "`keeponly'" ~= "" {
					keepifexist `keeponly'
					local keeplist "`r(keeplist)'"
				}
				else local keeplist "_all"
				cap drop month
				gen int month = `month'
				noi di "Processing CPS `samplename', `year'-`month': `keeplist'"
				tempfile monthlydata`month'
				save `monthlydata`month''
				erase `inputfile'
			}
		}
		qui {
			forvalues month = 1/12 {
				if `month' == 1 use `monthlydata`month'', clear
				else append using `monthlydata`month'', force
			}
			cap drop year
			gen int year = `year'
			tempfile annualdata`year'
			save `annualdata`year''
		}
	}
}

* append years of data together
qui foreach year of numlist `begin'(1)`end' {
	local counter = `counter' + 1
	if `counter' == 1 {
    use `annualdata`year'', clear
  }
  noi di "Loading CPS `samplename', `year'"
	else append using `annualdata`year'', force
}

end
